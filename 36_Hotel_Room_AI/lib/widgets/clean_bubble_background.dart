// lib/widgets/clean_bubble_background.dart
// Animated background with gradient and drifting blobs

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';

class CleanBubbleBackground extends StatefulWidget {
  const CleanBubbleBackground({super.key});

  @override
  State<CleanBubbleBackground> createState() => _CleanBubbleBackgroundState();
}

class _CleanBubbleBackgroundState extends State<CleanBubbleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 45), // Slow drift
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: HotelAIGradients.background,
            ),
          ),
        ),
        // Animated blobs
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _BubblePainter(
                  animation: _controller.value,
                ),
              );
            },
          ),
        ),
        // Subtle aqua bloom overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.3, -0.5),
                radius: 1.5,
                colors: [
                  HotelAIColors.leatherTan.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter({required this.animation});

  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Define 4 drifting blobs with different speeds and positions
    final blobs = [
      _BlobConfig(
        color: HotelAIColors.leatherTan.withValues(alpha: 0.04),
        startX: 0.2,
        startY: 0.3,
        radius: 0.4,
        speedX: 0.15,
        speedY: 0.1,
      ),
      _BlobConfig(
        color: HotelAIColors.metallicGold.withValues(alpha: 0.03),
        startX: 0.7,
        startY: 0.2,
        radius: 0.35,
        speedX: -0.12,
        speedY: 0.08,
      ),
      _BlobConfig(
        color: HotelAIColors.laceGray.withValues(alpha: 0.02),
        startX: 0.5,
        startY: 0.7,
        radius: 0.3,
        speedX: 0.1,
        speedY: -0.15,
      ),
      _BlobConfig(
        color: HotelAIColors.leatherTan.withValues(alpha: 0.03),
        startX: 0.1,
        startY: 0.8,
        radius: 0.25,
        speedX: 0.18,
        speedY: -0.12,
      ),
    ];

    for (final blob in blobs) {
      // Calculate drifting position
      final centerX = size.width *
          (blob.startX +
              math.sin(animation * 2 * math.pi) * blob.speedX);
      final centerY = size.height *
          (blob.startY +
              math.cos(animation * 2 * math.pi) * blob.speedY);

      paint.color = blob.color;

      // Create radial gradient for blob
      paint.shader = RadialGradient(
        colors: [
          blob.color,
          blob.color.withValues(alpha: 0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: size.width * blob.radius,
      ));

      canvas.drawCircle(
        Offset(centerX, centerY),
        size.width * blob.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class _BlobConfig {
  const _BlobConfig({
    required this.color,
    required this.startX,
    required this.startY,
    required this.radius,
    required this.speedX,
    required this.speedY,
  });

  final Color color;
  final double startX; // 0.0 - 1.0
  final double startY; // 0.0 - 1.0
  final double radius; // relative to screen width
  final double speedX; // drift speed horizontal
  final double speedY; // drift speed vertical
}
