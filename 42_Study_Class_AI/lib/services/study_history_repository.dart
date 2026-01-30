import 'database_service.dart';
import 'study_result_storage.dart';

class StudyHistoryRepository {
  final DatabaseService _db = DatabaseService.instance;
  final StudyResultStorage _storage = StudyResultStorage();

  static bool _migrationAttempted = false;

  Future<void> _ensureMigrated() async {
    if (!_migrationAttempted) {
      _migrationAttempted = true;
      await _db.migrateFromPrefs();
    }
  }

  Future<List<String>> getHistoryIds() async {
    await _ensureMigrated();
    return await _db.getHistoryIds();
  }

  Future<void> addToHistory(String id) async {
    await _ensureMigrated();
    await _db.touchResult(id);
  }

  Future<void> removeFromHistory(String id) async {
    await _ensureMigrated();
    await _storage.deleteResult(id);
  }

  Future<void> clearHistory() async {
    await _ensureMigrated();
    await _db.clearAll();
  }

  Future<int> getHistoryCount() async {
    await _ensureMigrated();
    return await _db.getHistoryCount();
  }
}
