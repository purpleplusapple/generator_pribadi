import 'package:flutter/material.dart';
import '../../../../theme/camper_theme.dart';
import '../../../../model/camper_style_def.dart';

class StyleControlSheet extends StatefulWidget {
  final CamperStyle style;
  final Map<String, dynamic> currentValues;
  final Function(String, dynamic) onUpdate;

  const StyleControlSheet({
    super.key,
    required this.style,
    required this.currentValues,
    required this.onUpdate,
  });

  @override
  State<StyleControlSheet> createState() => _StyleControlSheetState();
}

class _StyleControlSheetState extends State<StyleControlSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CamperAIColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Customize ${widget.style.name}", style: CamperAIText.h3),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const Divider(),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: widget.style.controls.map((control) => _buildControl(control)).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Apply Changes"),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(StyleControl control) {
    switch (control.type) {
      case ControlType.chips:
        return _buildChips(control);
      case ControlType.slider:
        return _buildSlider(control);
      case ControlType.toggle:
        return _buildToggle(control);
      case ControlType.stepper:
        return _buildStepper(control);
      case ControlType.text:
        return _buildTextField(control);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildChips(StyleControl control) {
    final selected = widget.currentValues[control.id] ?? control.defaultString ?? control.options!.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(control.label, style: CamperAIText.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: control.options!.map((opt) {
            final isSel = selected == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSel,
              selectedColor: CamperAIColors.leatherTan,
              labelStyle: TextStyle(color: isSel ? CamperAIColors.soleBlack : CamperAIColors.canvasWhite),
              onSelected: (val) {
                if (val) widget.onUpdate(control.id, opt);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSlider(StyleControl control) {
    final double val = (widget.currentValues[control.id] ?? control.defaultDouble ?? control.min!).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(control.label, style: CamperAIText.bodyMedium),
            Text(val.toStringAsFixed(0), style: CamperAIText.caption),
          ],
        ),
        Slider(
          value: val,
          min: control.min ?? 0,
          max: control.max ?? 100,
          activeColor: CamperAIColors.leatherTan,
          onChanged: (v) => widget.onUpdate(control.id, v),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildToggle(StyleControl control) {
    final bool val = widget.currentValues[control.id] ?? control.defaultBool ?? false;
    return SwitchListTile(
      title: Text(control.label, style: CamperAIText.bodyMedium),
      value: val,
      activeColor: CamperAIColors.leatherTan,
      contentPadding: EdgeInsets.zero,
      onChanged: (v) => widget.onUpdate(control.id, v),
    );
  }

  Widget _buildStepper(StyleControl control) {
    final int val = widget.currentValues[control.id] ?? control.defaultInt ?? 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(control.label, style: CamperAIText.bodyMedium),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: val > (control.min ?? 0) ? () => widget.onUpdate(control.id, val - 1) : null,
            ),
            Text(val.toString(), style: CamperAIText.h3),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: val < (control.max ?? 10) ? () => widget.onUpdate(control.id, val + 1) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(StyleControl control) {
    // Handling text field updates in bottom sheet is tricky with focus.
    // For prototype, basic Field.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(control.label, style: CamperAIText.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          onChanged: (v) => widget.onUpdate(control.id, v),
          decoration: InputDecoration(
            hintText: "Enter ${control.label}...",
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
