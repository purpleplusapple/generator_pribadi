import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../model/study_control.dart';
import '../model/study_style.dart';

class StyleControlSheet extends StatefulWidget {
  final StudyStyle style;
  final Map<String, dynamic> initialValues;
  final Function(Map<String, dynamic>) onApply;

  const StyleControlSheet({
    super.key,
    required this.style,
    required this.initialValues,
    required this.onApply,
  });

  @override
  State<StyleControlSheet> createState() => _StyleControlSheetState();
}

class _StyleControlSheetState extends State<StyleControlSheet> {
  late Map<String, dynamic> _values;

  @override
  void initState() {
    super.initState();
    _values = Map.from(widget.initialValues);
    // Initialize defaults if missing
    for (var control in widget.style.controls) {
      if (!_values.containsKey(control.id)) {
        _values[control.id] = control.defaultValue;
      }
    }
  }

  void _updateValue(String id, dynamic value) {
    setState(() {
      _values[id] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: StudyAIColors.bg1,
        borderRadius: StudyAIRadii.sheetRadius,
      ),
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SvgPicture.asset(
                  widget.style.tileAsset,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.style.name, style: StudyAIText.h2),
                    Text(
                      widget.style.description,
                      style: StudyAIText.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: StudyAIColors.line),

          // Controls List
          Expanded(
            child: ListView.separated(
              itemCount: widget.style.controls.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final control = widget.style.controls[index];
                return _buildControl(control);
              },
            ),
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onApply(_values);
              Navigator.pop(context);
            },
            child: const Text('Apply Style'),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(StudyControl control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(control.label, style: StudyAIText.bodyMedium),
            if (control.type == StudyControlType.slider)
              Text(
                '${(_values[control.id] as num).toInt()}${control.suffix ?? ''}',
                style: StudyAIText.bodySmall,
              ),
          ],
        ),
        const SizedBox(height: 8),
        _buildControlInput(control),
      ],
    );
  }

  Widget _buildControlInput(StudyControl control) {
    switch (control.type) {
      case StudyControlType.chips:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: control.options!.map((opt) {
            final isSelected = _values[control.id] == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (val) {
                if (val) _updateValue(control.id, opt);
              },
              backgroundColor: StudyAIColors.surface,
              selectedColor: StudyAIColors.primarySoft,
              labelStyle: TextStyle(
                color: isSelected ? StudyAIColors.primary : StudyAIColors.ink1,
              ),
            );
          }).toList(),
        );

      case StudyControlType.slider:
        return Slider(
          value: (_values[control.id] as num).toDouble(),
          min: control.min ?? 0,
          max: control.max ?? 100,
          divisions: control.divisions,
          onChanged: (val) => _updateValue(control.id, val),
          activeColor: StudyAIColors.primary,
          inactiveColor: StudyAIColors.surface,
        );

      case StudyControlType.toggle:
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(control.label, style: StudyAIText.bodySmall),
          value: _values[control.id] as bool,
          onChanged: (val) => _updateValue(control.id, val),
          activeColor: StudyAIColors.primary,
        );

      case StudyControlType.stepper:
        final val = _values[control.id] as int;
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: val > (control.min ?? 0)
                  ? () => _updateValue(control.id, val - 1)
                  : null,
            ),
            Text('$val', style: StudyAIText.h3),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: val < (control.max ?? 100)
                  ? () => _updateValue(control.id, val + 1)
                  : null,
            ),
          ],
        );

      case StudyControlType.text:
        return TextField(
          controller: TextEditingController(text: _values[control.id] as String)
            ..selection = TextSelection.collapsed(offset: (_values[control.id] as String).length),
          onChanged: (val) => _values[control.id] = val, // Direct update, no rebuild needed for text
          style: StudyAIText.body,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter specific details...',
          ),
        );

      case StudyControlType.multiSelect:
        final currentList = List<String>.from(_values[control.id] as List);
        return Wrap(
          spacing: 8,
          children: control.options!.map((opt) {
            final isSelected = currentList.contains(opt);
            return FilterChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    currentList.add(opt);
                  } else {
                    currentList.remove(opt);
                  }
                  _values[control.id] = currentList;
                });
              },
              backgroundColor: StudyAIColors.surface,
              selectedColor: StudyAIColors.primarySoft,
              labelStyle: TextStyle(
                color: isSelected ? StudyAIColors.primary : StudyAIColors.ink1,
              ),
            );
          }).toList(),
        );
    }
  }
}
