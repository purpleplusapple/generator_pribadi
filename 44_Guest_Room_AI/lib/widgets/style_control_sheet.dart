import 'package:flutter/material.dart';
import '../theme/guest_theme.dart';
import '../model/guest_style_definition.dart';
import '../widgets/gradient_button.dart';

class StyleControlSheet extends StatefulWidget {
  final GuestStyleDefinition style;
  final Map<String, dynamic> currentValues;
  final Function(String key, dynamic value) onValueChanged;
  final VoidCallback onApply;

  const StyleControlSheet({
    super.key,
    required this.style,
    required this.currentValues,
    required this.onValueChanged,
    required this.onApply,
  });

  @override
  State<StyleControlSheet> createState() => _StyleControlSheetState();
}

class _StyleControlSheetState extends State<StyleControlSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      decoration: const BoxDecoration(
        color: GuestAIColors.warmLinen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(GuestAIRadii.large)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customize Style", style: GuestAIText.small.copyWith(fontWeight: FontWeight.bold)),
                      Text(widget.style.name, style: GuestAIText.h2),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(),

          // Controls List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: widget.style.controls.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final control = widget.style.controls[index];
                return _buildControl(control);
              },
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GradientButton(
              label: "Apply Changes",
              onPressed: widget.onApply,
              size: ButtonSize.large,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(StyleControl control) {
    // Get current value or default
    final value = widget.currentValues[control.id] ?? control.defaultValue;

    switch (control.type) {
      case ControlType.slider:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(control.label, style: GuestAIText.bodyMedium),
                Text("${(value as num).toInt()}%", style: GuestAIText.small),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: GuestAIColors.brass,
                inactiveTrackColor: GuestAIColors.line,
                thumbColor: GuestAIColors.brass,
              ),
              child: Slider(
                value: (value as num).toDouble(),
                min: control.min ?? 0,
                max: control.max ?? 100,
                onChanged: (v) => widget.onValueChanged(control.id, v),
              ),
            ),
          ],
        );

      case ControlType.toggle:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(control.label, style: GuestAIText.bodyMedium),
            Switch(
              value: value as bool,
              activeColor: GuestAIColors.brass,
              onChanged: (v) => widget.onValueChanged(control.id, v),
            ),
          ],
        );

      case ControlType.chips:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(control.label, style: GuestAIText.bodyMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (control.options ?? []).map((opt) {
                final isSelected = opt == value;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor: GuestAIColors.brassSoft,
                  backgroundColor: GuestAIColors.pureWhite,
                  labelStyle: TextStyle(
                    color: isSelected ? GuestAIColors.inkTitle : GuestAIColors.inkBody,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  onSelected: (selected) {
                    if (selected) widget.onValueChanged(control.id, opt);
                  },
                );
              }).toList(),
            ),
          ],
        );

      case ControlType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(control.label, style: GuestAIText.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: value as String)
                ..selection = TextSelection.collapsed(offset: (value as String).length),
              onChanged: (v) => widget.onValueChanged(control.id, v),
              decoration: InputDecoration(
                hintText: "Enter details...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 3,
            ),
          ],
        );
    }
  }
}
