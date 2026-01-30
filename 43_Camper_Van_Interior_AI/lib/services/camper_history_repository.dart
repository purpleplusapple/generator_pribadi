// lib/services/camper_history_repository.dart
// Repository for managing history list via SharedPreferences

import 'package:shared_preferences/shared_preferences.dart';
import 'camper_storage.dart';

class CamperHistoryRepository {
  static const String _historyKey = 'camper_history_ids';
  final CamperResultStorage _storage = CamperResultStorage();

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  /// Get list of all result IDs in history (newest first)
  Future<List<String>> getHistoryIds() async {
    final prefs = await _prefs;
    return prefs.getStringList(_historyKey) ?? [];
  }

  /// Add a new result ID to history (at the beginning)
  Future<void> addToHistory(String id) async {
    final prefs = await _prefs;
    final ids = prefs.getStringList(_historyKey) ?? [];

    // Remove if exists (to move to top)
    ids.remove(id);
    ids.insert(0, id);

    await prefs.setStringList(_historyKey, ids);
  }

  /// Remove a result ID from history and delete its data
  Future<void> removeFromHistory(String id) async {
    final prefs = await _prefs;
    final ids = prefs.getStringList(_historyKey) ?? [];

    ids.remove(id);
    await prefs.setStringList(_historyKey, ids);

    // Delete actual data
    await _storage.deleteResult(id);
  }

  /// Clear all history and delete all result data
  Future<void> clearHistory() async {
    final prefs = await _prefs;
    final ids = prefs.getStringList(_historyKey) ?? [];

    for (final id in ids) {
      await _storage.deleteResult(id);
    }

    await prefs.remove(_historyKey);
  }

  Future<int> getHistoryCount() async {
    final ids = await getHistoryIds();
    return ids.length;
  }
}
