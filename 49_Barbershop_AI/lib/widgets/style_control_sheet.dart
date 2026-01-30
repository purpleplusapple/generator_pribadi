import 'package:flutter/material.dart';
import '../../theme/barber_theme.dart';
import '../../model/barber_style.dart';
import '../../model/barber_config.dart';

class StyleControlSheet extends StatefulWidget {
  final BarberStyle style;
  final BarberConfig currentConfig;
  final Function(String key, dynamic value) onUpdate;

  const StyleControlSheet({
    super.key,
    required this.style,
    required this.currentConfig,
    required this.onUpdate,
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
        color: BarberTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BarberTheme.muted.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customize ${widget.style.name}", style: BarberTheme.themeData.textTheme.titleLarge),
                      Text("Adjust the details for your shop", style: BarberTheme.themeData.textTheme.labelMedium),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 32),

          // Controls List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: widget.style.controls.length,
              separatorBuilder: (_,__) => const SizedBox(height: 20),
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

  Widget _buildControl(BarberControl control) {
    final currentValue = widget.currentConfig.controlValues[control.id] ?? control.defaultValue;

    switch (control.type) {
      case ControlType.chips:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(control.label, style: BarberTheme.themeData.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (control.options ?? []).map((opt) {
                final isSelected = currentValue == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) widget.onUpdate(control.id, opt);
                  },
                  selectedColor: BarberTheme.primary,
                  backgroundColor: BarberTheme.bg1,
                  labelStyle: TextStyle(
                    color: isSelected ? BarberTheme.bg0 : BarberTheme.ink1,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        );

      case ControlType.stepper:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(control.label, style: BarberTheme.themeData.textTheme.labelLarge),
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: () {
                    final val = (currentValue as num).toInt();
                    if (val > (control.min ?? 0)) {
                      widget.onUpdate(control.id, val - 1);
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    currentValue.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () {
                    final val = (currentValue as num).toInt();
                    if (val < (control.max ?? 100)) {
                      widget.onUpdate(control.id, val + 1);
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        );

      case ControlType.slider:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(control.label, style: BarberTheme.themeData.textTheme.labelLarge),
                Text("${(currentValue as num).toInt()}%", style: BarberTheme.themeData.textTheme.labelMedium),
              ],
            ),
            Slider(
              value: (currentValue as num).toDouble(),
              min: (control.min as num).toDouble(),
              max: (control.max as num).toDouble(),
              activeColor: BarberTheme.primary,
              onChanged: (val) => widget.onUpdate(control.id, val),
            ),
          ],
        );

      case ControlType.toggle:
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(control.label, style: BarberTheme.themeData.textTheme.labelLarge),
          value: currentValue as bool,
          activeColor: BarberTheme.primary,
          onChanged: (val) => widget.onUpdate(control.id, val),
        );

      case ControlType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(control.label, style: BarberTheme.themeData.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: currentValue as String,
              decoration: const InputDecoration(
                hintText: "Add specific instructions...",
              ),
              onChanged: (val) => widget.onUpdate(control.id, val),
            ),
          ],
        );
    }
  }
}
