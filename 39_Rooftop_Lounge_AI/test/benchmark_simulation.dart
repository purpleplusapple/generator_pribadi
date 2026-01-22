import 'dart:async';

// Mock Storage that simulates IO delay
class MockStorage {
  Future<void> deleteResult(String id) async {
    // Simulate 10ms delay per deletion (typical for file/db IO)
    await Future.delayed(Duration(milliseconds: 10));
  }
}

// Mock Preferences
class MockPrefs {
  Future<void> remove(String key) async {
    await Future.delayed(Duration(milliseconds: 5));
  }
}

Future<void> main() async {
  final storage = MockStorage();
  final prefs = MockPrefs();
  final ids = List.generate(100, (i) => 'id_$i');

  print('Running benchmark with ${ids.length} items...');

  // --- Baseline: Serial Execution ---
  final stopwatchSerial = Stopwatch()..start();

  // Delete all result data
  for (final id in ids) {
    await storage.deleteResult(id);
  }

  // Clear history list
  await prefs.remove('history_key');

  stopwatchSerial.stop();
  print('Serial Execution (Baseline): ${stopwatchSerial.elapsedMilliseconds}ms');

  // --- Optimized: Concurrent Execution ---
  final stopwatchConcurrent = Stopwatch()..start();

  // Delete all result data concurrently
  await Future.wait(ids.map((id) => storage.deleteResult(id)));

  // Clear history list
  await prefs.remove('history_key');

  stopwatchConcurrent.stop();
  print('Concurrent Execution (Optimized): ${stopwatchConcurrent.elapsedMilliseconds}ms');

  // Calculate improvement
  final improvement = stopwatchSerial.elapsedMilliseconds - stopwatchConcurrent.elapsedMilliseconds;
  final percent = (improvement / stopwatchSerial.elapsedMilliseconds * 100).toStringAsFixed(2);

  print('Improvement: ${improvement}ms ($percent%)');
}
