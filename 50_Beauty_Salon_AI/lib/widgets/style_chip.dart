// lib/widgets/style_chip.dart
// Selection chip for style options and categories

import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';

class StyleChip extends StatefulWidget {
  const StyleChip({
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
  State<StyleChip> createState() => _StyleChipState();
}

class _StyleChipState extends State<StyleChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: BeautyAIMotion.fast,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: BeautyAIMotion.standardEasing,
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
            horizontal: BeautyAISpacing.md,
            vertical: BeautyAISpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? BeautyAIColors.roseGold.withValues(alpha: 0.15)
                : BeautyAIColors.creamWhite.withValues(alpha: 0.05),
            borderRadius: BeautyAIRadii.chipRadius,
            border: Border.all(
              color: widget.isSelected
                  ? BeautyAIColors.roseGold
                  : BeautyAIColors.creamWhite.withValues(alpha: 0.2),
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
                      ? BeautyAIColors.roseGold
                      : BeautyAIColors.creamWhite,
                ),
                const SizedBox(width: BeautyAISpacing.xs),
              ],
              Text(
                widget.label,
                style: BeautyAIText.caption.copyWith(
                  color: widget.isSelected
                      ? BeautyAIColors.roseGold
                      : BeautyAIColors.creamWhite,
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
