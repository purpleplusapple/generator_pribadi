// lib/widgets/glass_card.dart
// Reusable glass morphism card component

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurSigma,
    this.fillOpacity,
    this.borderOpacity,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? blurSigma;
  final double? fillOpacity;
  final double? borderOpacity;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? ClinicRadius.cardRadius;
    final effectiveBlurSigma = blurSigma ?? ClinicGlass.cardBlurSigma;
    final effectiveFillOpacity = fillOpacity ?? ClinicGlass.fillOpacity;
    final effectiveBorderOpacity =
        borderOpacity ?? ClinicGlass.borderOpacity;
    final effectivePadding = padding ??
        const EdgeInsets.all(ClinicSpacing.base);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: ClinicColors.canvasWhite.withValues(
              alpha: effectiveFillOpacity,
            ),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: ClinicColors.canvasWhite.withValues(
                alpha: effectiveBorderOpacity,
              ),
              width: ClinicGlass.borderWidth,
            ),
            boxShadow: showShadow ? ClinicShadows.card : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
