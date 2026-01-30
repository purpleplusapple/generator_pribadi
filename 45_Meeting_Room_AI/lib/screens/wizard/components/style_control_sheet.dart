// lib/screens/wizard/components/style_control_sheet.dart
// Bottom sheet for configuring a specific style

import 'package:flutter/material.dart';
import '../../../theme/meeting_room_theme.dart';
import '../../../theme/meeting_tokens.dart';
import '../../../model/meeting_style.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/glass_card.dart';

class StyleControlSheet extends StatefulWidget {
  const StyleControlSheet({
    super.key,
    required this.style,
    required this.onApply,
  });

  final MeetingStyle style;
  final Function(Map<String, dynamic>) onApply;

  @override
  State<StyleControlSheet> createState() => _StyleControlSheetState();
}

class _StyleControlSheetState extends State<StyleControlSheet> {
  final Map<String, dynamic> _values = {};

  @override
  void initState() {
    super.initState();
    // Initialize defaults
    for (var control in widget.style.controls) {
      _values[control.id] = control.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MeetingTokens.bg0,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(MeetingTokens.radiusXL)),
        border: Border(top: BorderSide(color: MeetingTokens.line)),
        boxShadow: MeetingAIShadows.modal,
      ),
      padding: EdgeInsets.only(
        top: 8, // Handle drag handle
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: MeetingTokens.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.style.name, style: MeetingRoomText.h3),
                      Text(
                        widget.style.description,
                        style: MeetingRoomText.small,
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
          ),

          const Divider(height: 32, color: MeetingTokens.line),

          // Controls List
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  for (var control in widget.style.controls) ...[
                    _buildControl(control),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),

          // Apply Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: GradientButton(
              label: 'APPLY STYLE',
              icon: Icons.check,
              onPressed: () => widget.onApply(_values),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(StyleControl control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              control.label.toUpperCase(),
              style: MeetingRoomText.caption.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            if (control.type == ControlType.slider || control.type == ControlType.stepper)
               Text(
                 _values[control.id].toString(),
                 style: MeetingRoomText.bodySemiBold.copyWith(color: MeetingTokens.accent),
               ),
          ],
        ),
        const SizedBox(height: 12),
        _buildControlInput(control),
      ],
    );
  }

  Widget _buildControlInput(StyleControl control) {
    switch (control.type) {
      case ControlType.chips:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: control.options!.map((option) {
            final isSelected = _values[control.id] == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _values[control.id] = option);
              },
              backgroundColor: MeetingTokens.surface,
              selectedColor: MeetingTokens.accent,
              labelStyle: TextStyle(
                color: isSelected ? MeetingTokens.ink0 : MeetingTokens.muted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MeetingTokens.radiusSM),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : MeetingTokens.line,
                ),
              ),
            );
          }).toList(),
        );

      case ControlType.slider:
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: MeetingTokens.accent,
            inactiveTrackColor: MeetingTokens.surface2,
            thumbColor: MeetingTokens.ink0,
            overlayColor: MeetingTokens.accent.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: (_values[control.id] as num).toDouble(),
            min: control.min ?? 0,
            max: control.max ?? 100,
            divisions: (control.max! - control.min!).toInt(),
            onChanged: (val) {
              setState(() => _values[control.id] = val); // Keep as double? or int?
              if (control.step == 1) {
                 setState(() => _values[control.id] = val.round());
              }
            },
          ),
        );

      case ControlType.stepper:
        return Container(
          decoration: BoxDecoration(
            color: MeetingTokens.surface,
            borderRadius: BorderRadius.circular(MeetingTokens.radiusSM),
            border: Border.all(color: MeetingTokens.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  final val = _values[control.id] as int;
                  if (val > (control.min ?? 0)) {
                    setState(() => _values[control.id] = val - 1);
                  }
                },
              ),
              Text(
                _values[control.id].toString(),
                style: MeetingRoomText.h3,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final val = _values[control.id] as int;
                  if (val < (control.max ?? 100)) {
                    setState(() => _values[control.id] = val + 1);
                  }
                },
              ),
            ],
          ),
        );

      case ControlType.text:
        return TextField(
          controller: TextEditingController(text: _values[control.id] as String?)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: (_values[control.id] as String? ?? '').length),
            ),
          onChanged: (val) => _values[control.id] = val, // Don't setState for text to avoid rebuild loop
          maxLines: 3,
          style: MeetingRoomText.body,
          decoration: InputDecoration(
            hintText: 'Enter details...',
            filled: true,
            fillColor: MeetingTokens.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MeetingTokens.radiusMD),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
