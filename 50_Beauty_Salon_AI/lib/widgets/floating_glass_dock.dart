import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';

class FloatingGlassDock extends StatelessWidget {
  final Widget child;
  final double height;

  const FloatingGlassDock({
    super.key,
    required this.child,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        height: height,
        child: ClipRRect(
          borderRadius: BeautyAIRadii.lgRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BeautyAIRadii.lgRadius,
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                boxShadow: BeautyAIShadows.floating,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
