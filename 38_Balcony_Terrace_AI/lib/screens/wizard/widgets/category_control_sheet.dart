import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';
import '../../data/terrace_style_data.dart';
import '../../widgets/terrace_chip.dart';

class CategoryControlSheet extends StatefulWidget {
  final TerraceStyleCategory category;
  final Map<String, dynamic> currentValues;
  final Function(String key, dynamic value) onValueChanged;

  const CategoryControlSheet({
    super.key,
    required this.category,
    required this.currentValues,
    required this.onValueChanged,
  });

  @override
  State<CategoryControlSheet> createState() => _CategoryControlSheetState();
}

class _CategoryControlSheetState extends State<CategoryControlSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TerraceAIColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(TerraceAIRadii.xl)),
        boxShadow: TerraceAIShadows.modal,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TerraceAIColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.lg, vertical: TerraceAISpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Customize ${widget.category.title}',
                    style: TerraceAIText.h3.copyWith(fontSize: 18),
                  ),
                ),
                // Reset button could go here
              ],
            ),
          ),

          const Divider(),

          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(TerraceAISpacing.lg),
              itemCount: widget.category.controls.length,
              separatorBuilder: (_, __) => const SizedBox(height: TerraceAISpacing.xl),
              itemBuilder: (context, index) {
                final control = widget.category.controls[index];
                return _buildControl(control);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(TerraceControl control) {
    final value = widget.currentValues[control.id] ?? control.defaultValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          control.label,
          style: TerraceAIText.bodyMedium.copyWith(color: TerraceAIColors.muted),
        ),
        const SizedBox(height: TerraceAISpacing.sm),
        _buildControlInput(control, value),
      ],
    );
  }

  Widget _buildControlInput(TerraceControl control, dynamic currentValue) {
    switch (control.type) {
      case 'chip':
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: control.options!.map((option) {
            final isSelected = currentValue == option;
            return TerraceChip(
              label: option,
              isSelected: isSelected,
              onTap: () => widget.onValueChanged(control.id, option),
            );
          }).toList(),
        );

      case 'slider':
        double sliderVal = double.tryParse(currentValue.toString()) ?? control.min ?? 0;
        return Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: TerraceAIColors.primary,
                  inactiveTrackColor: TerraceAIColors.line,
                  thumbColor: TerraceAIColors.accent,
                ),
                child: Slider(
                  value: sliderVal,
                  min: control.min ?? 0,
                  max: control.max ?? 100,
                  onChanged: (val) => widget.onValueChanged(control.id, val.toStringAsFixed(0)),
                ),
              ),
            ),
            Text(
              sliderVal.toStringAsFixed(0),
              style: TerraceAIText.bodyMedium,
            ),
          ],
        );

      case 'toggle':
        bool isTrue = currentValue.toString().toLowerCase() == 'true';
        return Switch(
          value: isTrue,
          activeColor: TerraceAIColors.primary,
          onChanged: (val) => widget.onValueChanged(control.id, val.toString()),
        );

      case 'stepper':
        int stepVal = int.tryParse(currentValue.toString()) ?? 0;
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (stepVal > (control.min ?? 0)) {
                  widget.onValueChanged(control.id, (stepVal - 1).toString());
                }
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: TerraceAIColors.surface2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(stepVal.toString(), style: TerraceAIText.h3),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (stepVal < (control.max ?? 10)) {
                  widget.onValueChanged(control.id, (stepVal + 1).toString());
                }
              },
            ),
          ],
        );

      case 'note':
        return TextField(
          controller: TextEditingController(text: currentValue.toString())
            ..selection = TextSelection.collapsed(offset: currentValue.toString().length),
          style: TerraceAIText.body,
          maxLines: 3,
          onChanged: (val) => widget.onValueChanged(control.id, val),
          decoration: const InputDecoration(
            hintText: 'Add specific instructions...',
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
