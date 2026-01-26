import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoe_room_ai/theme/shoe_room_ai_theme.dart';

// Replicating _BlobConfig locally since it is private
class BlobConfig {
  const BlobConfig({
    required this.color,
    required this.startX,
    required this.startY,
    required this.radius,
    required this.speedX,
    required this.speedY,
  });

  final Color color;
  final double startX;
  final double startY;
  final double radius;
  final double speedX;
  final double speedY;
}

void main() {
  test('Benchmark blob list allocation', () {
    final stopwatch = Stopwatch();
    const iterations = 100000;

    // 1. Baseline: Allocation inside the loop
    stopwatch.start();
    for (int i = 0; i < iterations; i++) {
      final blobs = [
        BlobConfig(
          color: ShoeAIColors.leatherTan.withValues(alpha: 0.04),
          startX: 0.2,
          startY: 0.3,
          radius: 0.4,
          speedX: 0.15,
          speedY: 0.1,
        ),
        BlobConfig(
          color: ShoeAIColors.metallicGold.withValues(alpha: 0.03),
          startX: 0.7,
          startY: 0.2,
          radius: 0.35,
          speedX: -0.12,
          speedY: 0.08,
        ),
        BlobConfig(
          color: ShoeAIColors.laceGray.withValues(alpha: 0.02),
          startX: 0.5,
          startY: 0.7,
          radius: 0.3,
          speedX: 0.1,
          speedY: -0.15,
        ),
        BlobConfig(
          color: ShoeAIColors.leatherTan.withValues(alpha: 0.03),
          startX: 0.1,
          startY: 0.8,
          radius: 0.25,
          speedX: 0.18,
          speedY: -0.12,
        ),
      ];
      // Simulate usage to prevent dead code elimination
      expect(blobs.length, 4);
    }
    stopwatch.stop();
    final baselineTime = stopwatch.elapsedMicroseconds;
    print('Baseline (Allocation inside loop): ${baselineTime}µs');

    // 2. Optimization: Static/Cached list
    final cachedBlobs = [
      BlobConfig(
        color: ShoeAIColors.leatherTan.withValues(alpha: 0.04),
        startX: 0.2,
        startY: 0.3,
        radius: 0.4,
        speedX: 0.15,
        speedY: 0.1,
      ),
      BlobConfig(
        color: ShoeAIColors.metallicGold.withValues(alpha: 0.03),
        startX: 0.7,
        startY: 0.2,
        radius: 0.35,
        speedX: -0.12,
        speedY: 0.08,
      ),
      BlobConfig(
        color: ShoeAIColors.laceGray.withValues(alpha: 0.02),
        startX: 0.5,
        startY: 0.7,
        radius: 0.3,
        speedX: 0.1,
        speedY: -0.15,
      ),
      BlobConfig(
        color: ShoeAIColors.leatherTan.withValues(alpha: 0.03),
        startX: 0.1,
        startY: 0.8,
        radius: 0.25,
        speedX: 0.18,
        speedY: -0.12,
      ),
    ];

    stopwatch.reset();
    stopwatch.start();
    for (int i = 0; i < iterations; i++) {
      final blobs = cachedBlobs;
      // Simulate usage
      expect(blobs.length, 4);
    }
    stopwatch.stop();
    final optimizedTime = stopwatch.elapsedMicroseconds;
    print('Optimized (Cached list): ${optimizedTime}µs');

    final improvement = baselineTime - optimizedTime;
    final percent = baselineTime > 0 ? (improvement / baselineTime) * 100 : 0;
    print('Improvement: ${improvement}µs (${percent.toStringAsFixed(2)}%)');
  });
}
