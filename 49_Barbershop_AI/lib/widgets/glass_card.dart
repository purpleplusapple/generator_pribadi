import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/barber_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GlassCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BarberTheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BarberTheme.line.withOpacity(0.5)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
