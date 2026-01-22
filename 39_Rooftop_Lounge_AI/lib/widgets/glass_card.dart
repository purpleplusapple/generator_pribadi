import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurSigma = 10.0,
    this.fillOpacity = 0.05,
    this.borderOpacity = 0.1,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final double fillOpacity;
  final double borderOpacity;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(DesignTokens.radiusM);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignTokens.ink0.withOpacity(fillOpacity),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: DesignTokens.ink0.withOpacity(borderOpacity),
              width: 1,
            ),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
