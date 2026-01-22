// lib/widgets/laundry_chip.dart
// Selection chip for style options and categories

import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';

class LaundryChip extends StatefulWidget {
  const LaundryChip({
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
  State<LaundryChip> createState() => _LaundryChipState();
}

class _LaundryChipState extends State<LaundryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ClinicMotion.fast,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ClinicMotion.standardEasing,
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
            horizontal: ClinicSpacing.md,
            vertical: ClinicSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? ClinicColors.leatherTan.withValues(alpha: 0.15)
                : ClinicColors.canvasWhite.withValues(alpha: 0.05),
            borderRadius: ClinicRadius.chipRadius,
            border: Border.all(
              color: widget.isSelected
                  ? ClinicColors.leatherTan
                  : ClinicColors.canvasWhite.withValues(alpha: 0.2),
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
                      ? ClinicColors.leatherTan
                      : ClinicColors.canvasWhite,
                ),
                const SizedBox(width: ClinicSpacing.xs),
              ],
              Text(
                widget.label,
                style: ClinicText.caption.copyWith(
                  color: widget.isSelected
                      ? ClinicColors.leatherTan
                      : ClinicColors.canvasWhite,
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
