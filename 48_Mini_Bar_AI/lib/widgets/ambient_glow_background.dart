// lib/widgets/ambient_glow_background.dart
import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class AmbientGlowBackground extends StatelessWidget {
  const AmbientGlowBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MiniBarColors.bg0,
      child: Stack(
        children: [
          // Top Left Amber Glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MiniBarColors.primarySoft.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Bottom Right Emerald Hint
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MiniBarColors.emerald.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Blur mesh
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }
}
import 'dart:ui';
