// lib/widgets/terrace_chip.dart
// Selection chip for style options and categories

import 'package:flutter/material.dart';
import '../theme/balcony_terrace_ai_theme.dart';

class TerraceChip extends StatefulWidget {
  const TerraceChip({
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
  State<TerraceChip> createState() => _TerraceChipState();
}

class _TerraceChipState extends State<TerraceChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: TerraceAIMotion.fast,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: TerraceAIMotion.standardEasing,
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
            horizontal: TerraceAISpacing.md,
            vertical: TerraceAISpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? TerraceAIColors.leatherTan.withValues(alpha: 0.15)
                : TerraceAIColors.canvasWhite.withValues(alpha: 0.05),
            borderRadius: TerraceAIRadii.chipRadius,
            border: Border.all(
              color: widget.isSelected
                  ? TerraceAIColors.leatherTan
                  : TerraceAIColors.canvasWhite.withValues(alpha: 0.2),
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
                      ? TerraceAIColors.leatherTan
                      : TerraceAIColors.canvasWhite,
                ),
                const SizedBox(width: TerraceAISpacing.xs),
              ],
              Text(
                widget.label,
                style: TerraceAIText.caption.copyWith(
                  color: widget.isSelected
                      ? TerraceAIColors.leatherTan
                      : TerraceAIColors.canvasWhite,
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
