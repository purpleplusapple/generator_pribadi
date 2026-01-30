// lib/widgets/glass_card.dart
// Reusable glass morphism card component

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/meeting_room_theme.dart';

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
        borderRadius ?? MeetingAIRadii.cardRadius;
    final effectiveBlurSigma = blurSigma ?? MeetingAIGlass.cardBlurSigma;
    final effectiveFillOpacity = fillOpacity ?? MeetingAIGlass.fillOpacity;
    final effectiveBorderOpacity =
        borderOpacity ?? MeetingAIGlass.borderOpacity;
    final effectivePadding = padding ??
        const EdgeInsets.all(MeetingAISpacing.base);

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
            color: MeetingAIColors.canvasWhite.withValues(
              alpha: effectiveFillOpacity,
            ),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: MeetingAIColors.canvasWhite.withValues(
                alpha: effectiveBorderOpacity,
              ),
              width: MeetingAIGlass.borderWidth,
            ),
            boxShadow: showShadow ? MeetingAIShadows.card : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
