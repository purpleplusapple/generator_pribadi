// lib/widgets/glass_card.dart
// Reusable glass morphism card component

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/balcony_terrace_ai_theme.dart';

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
        borderRadius ?? TerraceAIRadii.cardRadius;
    final effectiveBlurSigma = blurSigma ?? TerraceAIGlass.cardBlurSigma;
    final effectiveFillOpacity = fillOpacity ?? TerraceAIGlass.fillOpacity;
    final effectiveBorderOpacity =
        borderOpacity ?? TerraceAIGlass.borderOpacity;
    final effectivePadding = padding ??
        const EdgeInsets.all(TerraceAISpacing.base);

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
            color: TerraceAIColors.canvasWhite.withValues(
              alpha: effectiveFillOpacity,
            ),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: TerraceAIColors.canvasWhite.withValues(
                alpha: effectiveBorderOpacity,
              ),
              width: TerraceAIGlass.borderWidth,
            ),
            boxShadow: showShadow ? TerraceAIShadows.card : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
