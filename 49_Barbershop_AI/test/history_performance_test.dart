import 'package:flutter_test/flutter_test.dart';
import 'package:barbershop_ai/services/laundry_history_repository.dart';
import 'package:barbershop_ai/services/shoe_result_storage.dart';
import 'package:barbershop_ai/model/shoe_ai_config.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  test('Performance benchmark for LaundryHistoryRepository', () async {
    // Setup sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final repository = LaundryHistoryRepository();
    final storage = LaundryResultStorage();

    // Clear history to start fresh
    await repository.clearHistory();

    // Create dummy config
    final config = ShoeAIConfig.empty();

    // Benchmark
    final stopwatch = Stopwatch()..start();
    final int itemCount = 1000;

    print('Starting benchmark: Adding $itemCount items...');

    for (int i = 0; i < itemCount; i++) {
      final id = await storage.saveResult(config);
      await repository.addToHistory(id);
    }

    stopwatch.stop();
    print('Benchmark complete.');
    print('Time taken to add $itemCount items: ${stopwatch.elapsedMilliseconds}ms');
    print('Average time per item: ${stopwatch.elapsedMilliseconds / itemCount}ms');

    // Verify count
    final count = await repository.getHistoryCount();
    expect(count, itemCount);

    // Cleanup
    await repository.clearHistory();
  });
}
