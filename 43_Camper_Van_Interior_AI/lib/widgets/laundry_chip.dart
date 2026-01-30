// lib/widgets/van_chip.dart
// Selection chip for style options and categories

import 'package:flutter/material.dart';
import '../theme/camper_van_ai_theme.dart';

class VanChip extends StatefulWidget {
  const VanChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  State<VanChip> createState() => _VanChipState();
}

class _VanChipState extends State<VanChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: CamperAIMotion.fast,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: CamperAIMotion.standardEasing,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CamperAISpacing.md,
            vertical: CamperAISpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? CamperAIColors.leatherTan.withValues(alpha: 0.15)
                : CamperAIColors.canvasWhite.withValues(alpha: 0.05),
            borderRadius: CamperAIRadii.chipRadius,
            border: Border.all(
              color: widget.isSelected
                  ? CamperAIColors.leatherTan
                  : CamperAIColors.canvasWhite.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: widget.isSelected
                      ? CamperAIColors.leatherTan
                      : CamperAIColors.canvasWhite,
                ),
                const SizedBox(width: CamperAISpacing.xs),
              ],
              Text(
                widget.label,
                style: CamperAIText.caption.copyWith(
                  color: widget.isSelected
                      ? CamperAIColors.leatherTan
                      : CamperAIColors.canvasWhite,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
