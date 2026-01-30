import 'package:flutter/material.dart';
import '../theme/camper_tokens.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CamperTokens.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(CamperTokens.radiusM),
        border: Border.all(
          color: CamperTokens.line,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
