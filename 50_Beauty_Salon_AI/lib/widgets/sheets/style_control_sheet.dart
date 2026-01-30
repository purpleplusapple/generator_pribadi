import 'package:flutter/material.dart';
import '../../model/beauty_config.dart';
import '../../theme/beauty_theme.dart';
import '../../theme/beauty_tokens.dart';

class StyleControlSheet extends StatefulWidget {
  final BeautyStyle style;
  final Map<String, dynamic> currentValues;
  final Function(String, dynamic) onUpdate;
  final VoidCallback onApply;

  const StyleControlSheet({
    super.key,
    required this.style,
    required this.currentValues,
    required this.onUpdate,
    required this.onApply,
  });

  @override
  State<StyleControlSheet> createState() => _StyleControlSheetState();
}

class _StyleControlSheetState extends State<StyleControlSheet> {
  // Local state to make UI responsive immediately
  late Map<String, dynamic> _localValues;

  @override
  void initState() {
    super.initState();
    _localValues = Map.from(widget.currentValues);
  }

  void _update(String key, dynamic value) {
    setState(() {
      _localValues[key] = value;
    });
    widget.onUpdate(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BeautyTheme.bg0,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BeautyTheme.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.style.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Customize your salon details',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: widget.onApply,
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Controls List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              itemCount: widget.style.controls.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final control = widget.style.controls[index];
                return _buildControl(control);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(ControlDefinition control) {
    final value = _localValues[control.id] ?? control.defaultValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          control.label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        _buildControlInput(control, value),
      ],
    );
  }

  Widget _buildControlInput(ControlDefinition control, dynamic value) {
    switch (control.type) {
      case ControlType.chips:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (control.options ?? []).map((option) {
            final isSelected = value.toString() == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              selectedColor: BeautyTheme.primarySoft,
              labelStyle: TextStyle(
                color: isSelected ? BeautyTheme.primary : BeautyTheme.ink1,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              onSelected: (selected) {
                if (selected) _update(control.id, option);
              },
            );
          }).toList(),
        );

      case ControlType.slider:
        return Row(
          children: [
             Expanded(
               child: Slider(
                 value: (value as num).toDouble(),
                 min: control.min ?? 0,
                 max: control.max ?? 100,
                 activeColor: BeautyTheme.primary,
                 inactiveColor: BeautyTheme.line,
                 onChanged: (val) {
                   _update(control.id, val);
                 },
               ),
             ),
             Text(
               (value as num).toStringAsFixed(0),
               style: const TextStyle(color: BeautyTheme.muted),
             ),
          ],
        );

      case ControlType.stepper:
        final intVal = (value as num).toInt();
        return Row(
          children: [
            IconButton(
              onPressed: intVal > (control.minInt ?? 0)
                  ? () => _update(control.id, intVal - 1)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: BeautyTheme.primary,
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                '$intVal',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            IconButton(
              onPressed: intVal < (control.maxInt ?? 100)
                  ? () => _update(control.id, intVal + 1)
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              color: BeautyTheme.primary,
            ),
          ],
        );

      case ControlType.toggle:
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(value ? 'Enabled' : 'Disabled', style: const TextStyle(fontSize: 14)),
          value: value as bool,
          activeColor: BeautyTheme.primary,
          onChanged: (val) => _update(control.id, val),
        );
    }
  }
}
