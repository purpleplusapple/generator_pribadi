// lib/services/shoe_history_repository.dart
// Repository for managing history list of saved results

import 'database_service.dart';
import 'rooftop_result_storage.dart';

class RooftopHistoryRepository {
  final DatabaseService _db = DatabaseService.instance;
  final RooftopResultStorage _storage = RooftopResultStorage();

  // Flag to track if migration has been attempted
  static bool _migrationAttempted = false;

  /// Ensure migration is done.
  Future<void> _ensureMigrated() async {
    if (!_migrationAttempted) {
      _migrationAttempted = true;
      await _db.migrateFromPrefs();
    }
  }

  /// Get list of all result IDs in history (newest first)
  Future<List<String>> getHistoryIds() async {
    await _ensureMigrated();
    return await _db.getHistoryIds();
  }

  /// Add a new result ID to history (at the beginning)
  Future<void> addToHistory(String id) async {
    await _ensureMigrated();
    // Update timestamp to make it newest.
    // Note: The item must presumably exist in the database (saved via RooftopResultStorage).
    // If it doesn't, this might be a no-op, but addToHistory generally implies the item is being tracked.
    await _db.touchResult(id);
  }

  /// Remove a result ID from history and delete its data
  Future<void> removeFromHistory(String id) async {
    await _ensureMigrated();
    // Deleting the result removes it from history effectively
    await _storage.deleteResult(id);
  }

  /// Clear all history and delete all result data
  Future<void> clearHistory() async {
    await _ensureMigrated();
    await _db.clearAll();
  }

  /// Get count of items in history
  Future<int> getHistoryCount() async {
    await _ensureMigrated();
    return await _db.getHistoryCount();
  }
}
