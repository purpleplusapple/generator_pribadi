import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/terrace_theme.dart';

class NightBokehBackground extends StatefulWidget {
  const NightBokehBackground({super.key});

  @override
  State<NightBokehBackground> createState() => _NightBokehBackgroundState();
}

class _NightBokehBackgroundState extends State<NightBokehBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_BokehParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 20; i++) {
      _particles.add(_createParticle());
    }
  }

  _BokehParticle _createParticle() {
    return _BokehParticle(
      position: Offset(
        _random.nextDouble(),
        _random.nextDouble(),
      ),
      size: 50 + _random.nextDouble() * 150,
      color: _random.nextBool()
          ? TerraceAIColors.primary.withValues(alpha: 0.05 + _random.nextDouble() * 0.05)
          : TerraceAIColors.accent.withValues(alpha: 0.05 + _random.nextDouble() * 0.05),
      speed: 0.02 + _random.nextDouble() * 0.05,
      direction: _random.nextDouble() * 2 * pi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TerraceAIColors.bg0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _BokehPainter(
              particles: _particles,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BokehParticle {
  Offset position;
  final double size;
  final Color color;
  final double speed;
  final double direction;

  _BokehParticle({
    required this.position,
    required this.size,
    required this.color,
    required this.speed,
    required this.direction,
  });

  void update() {
    double dx = cos(direction) * speed * 0.002;
    double dy = sin(direction) * speed * 0.002;

    double newX = position.dx + dx;
    double newY = position.dy + dy;

    // Wrap around
    if (newX < -0.2) newX = 1.2;
    if (newX > 1.2) newX = -0.2;
    if (newY < -0.2) newY = 1.2;
    if (newY > 1.2) newY = -0.2;

    position = Offset(newX, newY);
  }
}

class _BokehPainter extends CustomPainter {
  final List<_BokehParticle> particles;
  final double progress;

  _BokehPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      particle.update(); // Update position logic here or in state, fine here for simple visual

      paint.color = particle.color;

      // Draw fuzzy circle
      final center = Offset(
        particle.position.dx * size.width,
        particle.position.dy * size.height,
      );

      // Use masking for bokeh effect (simple circle for now)
      canvas.drawCircle(center, particle.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BokehPainter oldDelegate) => true;
}
