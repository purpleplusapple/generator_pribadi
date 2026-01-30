import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';
import '../../../model/camper_style.dart';

class StyleControlSheet extends StatefulWidget {
  final CamperStyle style;
  final Map<String, dynamic> currentValues;
  final Function(String, dynamic) onValueChanged;
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
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: CamperTokens.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(CamperTokens.radiusL)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Customize ${widget.style.name}", style: Theme.of(context).textTheme.titleLarge),
              IconButton(onPressed: widget.onApply, icon: const Icon(Icons.close)),
            ],
          ),
          const Divider(color: CamperTokens.line),

          // Controls List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.style.controls.length,
              separatorBuilder: (c, i) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final control = widget.style.controls[index];
                return _buildControl(control);
              },
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: widget.onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: CamperTokens.primary,
              foregroundColor: Colors.black,
            ),
            child: const Text("Apply Customizations"),
          )
        ],
      ),
    );
  }

  Widget _buildControl(StyleControl control) {
    final currentValue = widget.currentValues[control.id] ?? control.defaultValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(control.label, style: const TextStyle(color: CamperTokens.muted, fontSize: 12)),
        const SizedBox(height: 8),
        if (control.type == ControlType.chips) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: control.options!.map((opt) {
              final isSelected = currentValue == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: isSelected,
                onSelected: (sel) {
                  if (sel) widget.onValueChanged(control.id, opt);
                },
                selectedColor: CamperTokens.primary,
                backgroundColor: CamperTokens.bg0,
                labelStyle: TextStyle(color: isSelected ? Colors.black : CamperTokens.ink0),
              );
            }).toList(),
          )
        ] else if (control.type == ControlType.slider) ...[
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: (currentValue as num).toDouble(),
                  min: control.min!,
                  max: control.max!,
                  divisions: (control.max! - control.min!).toInt(),
                  label: currentValue.toString(),
                  onChanged: (val) {
                    widget.onValueChanged(control.id, val);
                  },
                ),
              ),
              Text(currentValue.toStringAsFixed(0), style: const TextStyle(color: CamperTokens.ink0)),
            ],
          )
        ] else if (control.type == ControlType.stepper) ...[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                   final val = (currentValue as int);
                   if (val > 0) widget.onValueChanged(control.id, val - 1);
                },
              ),
              Text(currentValue.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                   final val = (currentValue as int);
                   widget.onValueChanged(control.id, val + 1);
                },
              ),
            ],
          )
        ]
      ],
    );
  }
}
