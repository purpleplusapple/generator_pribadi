// lib/widgets/gradient_button.dart
// Primary CTA button with gradient background

import 'package:flutter/material.dart';
import '../theme/terrace_theme.dart';

enum ButtonSize {
  standard,
  large,
}

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.standard,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ButtonSize size;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: TerraceMotion.fast,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: TerraceMotion.buttonPressScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: TerraceMotion.standardEasing,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    final height = widget.size == ButtonSize.large ? 60.0 : 50.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? LinearGradient(
                    colors: [
                      TerraceColors.laceGray.withValues(alpha: 0.3),
                      TerraceColors.laceGray.withValues(alpha: 0.3),
                    ],
                  )
                : TerraceGradients.primaryCta,
            borderRadius: TerraceRadii.buttonRadius,
            border: Border.all(
              color: isDisabled
                  ? Colors.transparent
                  : TerraceColors.metallicGold.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: isDisabled
                ? null
                : [
                    // Primary shadow
                    BoxShadow(
                      color: TerraceColors.leatherTan.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                    // Secondary glow
                    BoxShadow(
                      color: TerraceColors.metallicGold.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        TerraceColors.soleBlack,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: TerraceColors.soleBlack,
                          size: widget.size == ButtonSize.large ? 24 : 20,
                        ),
                        const SizedBox(width: TerraceSpacing.md), // Increased spacing
                      ],
                      Text(
                        widget.label,
                        style: TerraceText.button.copyWith(
                          color: TerraceColors.soleBlack,
                          fontSize: widget.size == ButtonSize.large ? 18 : 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
