import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe_room_ai/services/preferences_service.dart';
import 'package:shoe_room_ai/services/shoe_result_storage.dart';
import 'package:shoe_room_ai/model/shoe_ai_config.dart';

void main() {
  test('Benchmark N+1 vs Batch loading', () async {
    // Setup
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.instance.init();
    final storage = LaundryResultStorage();

    // Create dummy data
    final count = 1000;
    final ids = <String>[];
    for (int i = 0; i < count; i++) {
      final config = ShoeAIConfig(
        timestamp: DateTime.now(),
        styleSelections: {'style': 'modern', 'color': 'red'},
        originalImagePath: '/path/to/image_$i.jpg',
      );
      final id = await storage.saveResult(config);
      ids.add(id);
    }

    // Benchmark N+1 Loading
    // In the original code, this was done via FutureBuilder in the UI,
    // which adds significant overhead per item (Stream/Future scheduling, widget rebuilds).
    // Here we measure the raw data access latency difference.
    final stopwatchN1 = Stopwatch()..start();
    for (final id in ids) {
      await storage.loadResult(id);
    }
    stopwatchN1.stop();
    print('N+1 Loading Time for $count items: ${stopwatchN1.elapsedMilliseconds}ms');

    // Benchmark Batch Loading
    final stopwatchBatch = Stopwatch()..start();
    await storage.loadResults(ids);
    stopwatchBatch.stop();
    print('Batch Loading Time for $count items: ${stopwatchBatch.elapsedMilliseconds}ms');

    // Expectation: Batch should be faster due to less async scheduling overhead.
    // The real gain is in the UI thread not being blocked by N+1 Futures completing and triggering rebuilds.
  });
}
