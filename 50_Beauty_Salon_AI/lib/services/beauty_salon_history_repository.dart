// lib/services/beauty_salon_history_repository.dart
// Repository for managing history list of saved results

import 'preferences_service.dart';
import 'beauty_salon_result_storage.dart';

class BeautySalonHistoryRepository {
  static const String _historyKey = 'beauty_salon_history_ids';

  final PreferencesService _prefs = PreferencesService.instance;
  final BeautySalonResultStorage _storage = BeautySalonResultStorage();

  /// Get list of all result IDs in history (newest first)
  Future<List<String>> getHistoryIds() async {
    final ids = _prefs.getStringList(_historyKey) ?? [];
    return ids;
  }

  /// Add a new result ID to history (at the beginning)
  Future<void> addToHistory(String id) async {
    final ids = await getHistoryIds();

    // Remove if already exists (to avoid duplicates)
    ids.remove(id);

    // Add to beginning (newest first)
    ids.insert(0, id);

    await _prefs.setStringList(_historyKey, ids);
  }

  /// Remove a result ID from history and delete its data
  Future<void> removeFromHistory(String id) async {
    final ids = await getHistoryIds();
    ids.remove(id);
    await _prefs.setStringList(_historyKey, ids);

    // Also delete the result data
    await _storage.deleteResult(id);
  }

  /// Clear all history and delete all result data
  Future<void> clearHistory() async {
    final ids = await getHistoryIds();

    // Delete all result data
    for (final id in ids) {
      await _storage.deleteResult(id);
    }

    // Clear history list
    await _prefs.remove(_historyKey);
  }

  /// Get count of items in history
  Future<int> getHistoryCount() async {
    final ids = await getHistoryIds();
    return ids.length;
  }
}
