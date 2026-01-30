// lib/widgets/glass_card.dart
// Reusable glass morphism card component for Camper Van AI

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/camper_theme.dart';

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
        borderRadius ?? CamperAIRadii.cardRadius;
    final effectiveBlurSigma = blurSigma ?? CamperAIGlass.cardBlurSigma;
    final effectiveFillOpacity = fillOpacity ?? CamperAIGlass.fillOpacity;
    final effectiveBorderOpacity =
        borderOpacity ?? CamperAIGlass.borderOpacity;
    final effectivePadding = padding ??
        const EdgeInsets.all(CamperAISpacing.base);

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
            color: CamperAIColors.canvasWhite.withValues(
              alpha: effectiveFillOpacity,
            ),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: CamperAIColors.canvasWhite.withValues(
                alpha: effectiveBorderOpacity,
              ),
              width: CamperAIGlass.borderWidth,
            ),
            boxShadow: showShadow ? CamperAIShadows.card : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
