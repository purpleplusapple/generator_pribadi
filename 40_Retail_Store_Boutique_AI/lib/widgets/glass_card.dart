// lib/widgets/glass_card.dart
// Reusable glass morphism card component

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/boutique_theme.dart';

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
    final effectiveBorderRadius = borderRadius ?? BoutiqueRadii.cardRadius;
    final effectiveBlurSigma = blurSigma ?? BoutiqueGlass.blurSigma;

    // Default opacity for dark theme glass
    final effectiveFillOpacity = fillOpacity ?? 0.05;
    final effectiveBorderOpacity = borderOpacity ?? BoutiqueGlass.borderOpacity;

    final effectivePadding = padding ?? const EdgeInsets.all(BoutiqueSpacing.base);

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
            gradient: BoutiqueGradients.glassGradient,
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha: effectiveBorderOpacity),
              width: 1,
            ),
            boxShadow: showShadow ? BoutiqueShadows.card : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
