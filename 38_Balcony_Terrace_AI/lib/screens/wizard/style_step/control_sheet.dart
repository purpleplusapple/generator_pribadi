import 'package:flutter/material.dart';
import '../../../theme/design_tokens.dart';
import '../../../theme/terrace_theme.dart';
import '../../../data/style_categories.dart';

class ControlSheet extends StatefulWidget {
  final StyleCategory category;
  final Map<String, dynamic> currentValues;
  final Function(String, dynamic) onValueChanged;
  final Function(String) onUserNoteChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const ControlSheet({
    super.key,
    required this.category,
    required this.currentValues,
    required this.onValueChanged,
    required this.onUserNoteChanged,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<ControlSheet> createState() => _ControlSheetState();
}

class _ControlSheetState extends State<ControlSheet> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                ...widget.category.controls.map(_buildControl),
                const SizedBox(height: 24),
                _buildUserNote(),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.category.title,
            style: terraceTheme.textTheme.headlineMedium?.copyWith(
              color: DesignTokens.ink0,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: DesignTokens.muted),
            onPressed: widget.onApply, // Close sheet
          ),
        ],
      ),
    );
  }

  Widget _buildControl(ControlSpec control) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(control.label, style: const TextStyle(color: DesignTokens.ink1, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _buildControlInput(control),
        ],
      ),
    );
  }

  Widget _buildControlInput(ControlSpec control) {
    final value = widget.currentValues[control.id];

    switch (control.type) {
      case ControlType.chips:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: control.options!.map((option) {
            final isSelected = value == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) widget.onValueChanged(control.id, option);
              },
              backgroundColor: DesignTokens.surface2,
              selectedColor: DesignTokens.primary,
              labelStyle: TextStyle(
                color: isSelected ? DesignTokens.bg0 : DesignTokens.ink1,
              ),
              side: BorderSide(color: isSelected ? Colors.transparent : DesignTokens.line),
            );
          }).toList(),
        );

      case ControlType.slider:
        final sliderValue = (value as num?)?.toDouble() ?? control.defaultValue ?? 0;
        return Row(
          children: [
            Expanded(
              child: Slider(
                value: sliderValue,
                min: control.min ?? 0,
                max: control.max ?? 100,
                activeColor: DesignTokens.primary,
                inactiveColor: DesignTokens.surface2,
                onChanged: (val) => widget.onValueChanged(control.id, val),
              ),
            ),
            Text('${sliderValue.round()}', style: const TextStyle(color: DesignTokens.muted)),
          ],
        );

      case ControlType.toggle:
        // Render as segmented or chips for toggles
        return Wrap(
          spacing: 8,
          children: control.options!.map((option) {
             final isSelected = value == option;
             return GestureDetector(
               onTap: () => widget.onValueChanged(control.id, option),
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 decoration: BoxDecoration(
                   color: isSelected ? DesignTokens.primary.withOpacity(0.2) : DesignTokens.surface2,
                   borderRadius: BorderRadius.circular(12),
                   border: Border.all(color: isSelected ? DesignTokens.primary : DesignTokens.line),
                 ),
                 child: Text(
                   option,
                   style: TextStyle(
                     color: isSelected ? DesignTokens.primary : DesignTokens.muted,
                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                   ),
                 ),
               ),
             );
          }).toList(),
        );

      case ControlType.stepper:
        final count = (value as num?) ?? control.defaultValue ?? 1;
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: DesignTokens.muted),
              onPressed: () {
                if (count > (control.min ?? 0)) {
                  widget.onValueChanged(control.id, count - 1);
                }
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: DesignTokens.surface2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('$count', style: const TextStyle(color: DesignTokens.ink0, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: DesignTokens.muted),
              onPressed: () {
                if (count < (control.max ?? 100)) {
                  widget.onValueChanged(control.id, count + 1);
                }
              },
            ),
          ],
        );
    }
  }

  Widget _buildUserNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Specific Requests (Optional)', style: TextStyle(color: DesignTokens.ink1, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 2,
          onChanged: widget.onUserNoteChanged,
          decoration: const InputDecoration(
            hintText: 'e.g. Add a red pillow, keep it very dark...',
          ),
          style: const TextStyle(color: DesignTokens.ink0),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onReset,
            child: const Text('Reset'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: widget.onApply,
            child: const Text('Apply Settings'),
          ),
        ),
      ],
    );
  }
}
