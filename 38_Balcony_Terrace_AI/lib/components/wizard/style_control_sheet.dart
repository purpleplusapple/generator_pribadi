import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';
import '../../model/style_definition.dart';
import '../../model/style_control.dart';

class StyleControlSheet extends StatefulWidget {
  final StyleDefinition style;
  final Map<String, dynamic> initialValues;
  final Function(Map<String, dynamic>) onSave;

  const StyleControlSheet({
    super.key,
    required this.style,
    required this.initialValues,
    required this.onSave,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: TerraceColors.bg0,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TerraceColors.laceGray.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TerraceSpacing.xl),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.style.title, style: TerraceText.h2),
                      Text('Customize this style', style: TerraceText.caption),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 32),

          // Controls
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(TerraceSpacing.xl),
              itemCount: widget.style.controls.length,
              separatorBuilder: (_, __) => const SizedBox(height: TerraceSpacing.xl),
              itemBuilder: (context, index) {
                final control = widget.style.controls[index];
                return _buildControl(control);
              },
            ),
          ),

          // Action
          Padding(
            padding: const EdgeInsets.all(TerraceSpacing.xl),
            child: ElevatedButton(
              onPressed: () => widget.onSave(_values),
              style: ElevatedButton.styleFrom(
                backgroundColor: TerraceColors.primaryEmerald,
                foregroundColor: TerraceColors.soleBlack,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Apply Style'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(StyleControl control) {
    switch (control.type) {
      case ControlType.slider:
        return _buildSlider(control);
      case ControlType.chips:
        return _buildChips(control);
      case ControlType.toggle:
        return _buildToggle(control);
      case ControlType.text:
        return _buildTextField(control);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSlider(StyleControl control) {
    final value = (_values[control.id] as num?)?.toDouble() ?? control.min ?? 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(control.label, style: TerraceText.bodyMedium),
            Text(
              '${value.toInt()}${control.suffix ?? ''}',
              style: TerraceText.bodySmall.copyWith(color: TerraceColors.metallicGold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: control.min ?? 0,
          max: control.max ?? 100,
          divisions: control.divisions,
          activeColor: TerraceColors.metallicGold,
          inactiveColor: TerraceColors.surface,
          onChanged: (v) => setState(() => _values[control.id] = v),
        ),
      ],
    );
  }

  Widget _buildChips(StyleControl control) {
    final selected = _values[control.id] as String?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(control.label, style: TerraceText.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (control.options ?? []).map((opt) {
            final isSelected = selected == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (v) => setState(() => _values[control.id] = opt),
              backgroundColor: TerraceColors.surface,
              selectedColor: TerraceColors.primaryEmerald,
              labelStyle: TextStyle(
                color: isSelected ? TerraceColors.soleBlack : TerraceColors.ink0,
              ),
              side: BorderSide.none,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggle(StyleControl control) {
    final value = _values[control.id] as bool? ?? false;
    return SwitchListTile(
      title: Text(control.label, style: TerraceText.bodyMedium),
      value: value,
      onChanged: (v) => setState(() => _values[control.id] = v),
      activeColor: TerraceColors.metallicGold,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildTextField(StyleControl control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(control.label, style: TerraceText.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: _values[control.id] as String?)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: (_values[control.id] as String? ?? '').length),
            ),
          onChanged: (v) => _values[control.id] = v,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter specific requirements...',
            filled: true,
            fillColor: TerraceColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
