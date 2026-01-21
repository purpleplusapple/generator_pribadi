// lib/widgets/glass_card.dart
// Reusable glass morphism card component

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';

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
        borderRadius ?? BeautyAIRadii.cardRadius;
    final effectiveBlurSigma = blurSigma ?? BeautyAIGlass.cardBlurSigma;
    final effectiveFillOpacity = fillOpacity ?? BeautyAIGlass.fillOpacity;
    final effectiveBorderOpacity =
        borderOpacity ?? BeautyAIGlass.borderOpacity;
    final effectivePadding = padding ??
        const EdgeInsets.all(BeautyAISpacing.base);

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
            color: BeautyAIColors.creamWhite.withValues(
              alpha: effectiveFillOpacity,
            ),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: BeautyAIColors.creamWhite.withValues(
                alpha: effectiveBorderOpacity,
              ),
              width: BeautyAIGlass.borderWidth,
            ),
            boxShadow: showShadow ? BeautyAIShadows.card : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
