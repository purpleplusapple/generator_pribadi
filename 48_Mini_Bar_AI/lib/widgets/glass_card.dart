// lib/widgets/glass_card.dart
// Reusable glass morphism card component

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/shoe_room_ai_theme.dart';

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
        borderRadius ?? ShoeAIRadii.cardRadius;
    final effectiveBlurSigma = blurSigma ?? ShoeAIGlass.cardBlurSigma;
    final effectiveFillOpacity = fillOpacity ?? ShoeAIGlass.fillOpacity;
    final effectiveBorderOpacity =
        borderOpacity ?? ShoeAIGlass.borderOpacity;
    final effectivePadding = padding ??
        const EdgeInsets.all(ShoeAISpacing.base);

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
            color: ShoeAIColors.canvasWhite.withValues(
              alpha: effectiveFillOpacity,
            ),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: ShoeAIColors.canvasWhite.withValues(
                alpha: effectiveBorderOpacity,
              ),
              width: ShoeAIGlass.borderWidth,
            ),
            boxShadow: showShadow ? ShoeAIShadows.card : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
