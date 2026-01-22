import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';

class BeforeAfterPillToggle extends StatefulWidget {
  final bool isAfter;
  final ValueChanged<bool> onToggle;

  const BeforeAfterPillToggle({
    super.key,
    required this.isAfter,
    required this.onToggle,
  });

  @override
  State<BeforeAfterPillToggle> createState() => _BeforeAfterPillToggleState();
}

class _BeforeAfterPillToggleState extends State<BeforeAfterPillToggle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 200,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: BeautyAIColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: BeautyAIColors.line),
        boxShadow: BeautyAIShadows.soft,
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: BeautyAIMotion.fast,
            curve: Curves.easeInOut,
            alignment: widget.isAfter ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 96,
              height: 40,
              decoration: BoxDecoration(
                color: BeautyAIColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: BeautyAIColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _buildOption('Before', !widget.isAfter),
              _buildOption('After', widget.isAfter),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onToggle(label == 'After'),
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: BeautyAIMotion.fast,
            style: BeautyAIText.button.copyWith(
              color: isSelected ? Colors.white : BeautyAIColors.muted,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
