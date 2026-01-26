import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurSigma = 10,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? DesignTokens.rMedium,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignTokens.surface.withOpacity(0.6),
            borderRadius: borderRadius ?? DesignTokens.rMedium,
            border: Border.all(
              color: DesignTokens.line.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: showShadow ? DesignTokens.shadowSoft : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
