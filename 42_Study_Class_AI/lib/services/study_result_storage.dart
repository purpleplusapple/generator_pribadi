import 'dart:convert';
import '../model/study_ai_config.dart';
import 'database_service.dart';

class StudyResultStorage {
  final DatabaseService _db = DatabaseService.instance;

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String> saveResult(StudyAIConfig config) async {
    final id = _generateId();
    await _db.insertResult(id, config.toJson());
    return id;
  }

  Future<StudyAIConfig?> loadResult(String id) async {
    final map = await _db.getResult(id);
    if (map == null) return null;

    try {
      return StudyAIConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  Future<List<StudyAIConfig?>> loadResults(List<String> ids) async {
    final List<StudyAIConfig?> results = [];
    for (final id in ids) {
      results.add(await loadResult(id));
    }
    return results;
  }

  Future<void> deleteResult(String id) async {
    await _db.deleteResult(id);
  }

  Future<bool> hasResult(String id) async {
    return await _db.hasResult(id);
  }
}
