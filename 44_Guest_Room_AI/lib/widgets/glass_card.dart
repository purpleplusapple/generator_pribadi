import 'package:flutter/material.dart';
import '../theme/guest_theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurSigma, // Ignored
    this.fillOpacity, // Ignored
    this.borderOpacity, // Ignored
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
    return Card(
      elevation: showShadow ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(GuestAIRadii.regular),
        side: const BorderSide(color: GuestAIColors.line),
      ),
      color: GuestAIColors.pureWhite,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(GuestAISpacing.base),
        child: child,
      ),
    );
  }
}
