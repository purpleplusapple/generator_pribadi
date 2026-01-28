// lib/services/terrace_result_storage.dart
// Storage service for individual TerraceAIConfig results

import 'dart:convert';
import '../model/terrace_ai_config.dart';
import 'database_service.dart';

class TerraceResultStorage {
  final DatabaseService _db = DatabaseService.instance;

  /// Generate unique ID based on timestamp
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save a TerraceAIConfig and return its unique ID
  Future<String> saveResult(TerraceAIConfig config) async {
    final id = _generateId();
    await _db.insertResult(id, config.toJson());
    return id;
  }

  /// Load a TerraceAIConfig by ID
  Future<TerraceAIConfig?> loadResult(String id) async {
    final map = await _db.getResult(id);
    if (map == null) return null;

    try {
      return TerraceAIConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Load multiple TerraceAIConfig results by ID
  Future<List<TerraceAIConfig?>> loadResults(List<String> ids) async {
    List<TerraceAIConfig?> results = [];
    for (var id in ids) {
      results.add(await loadResult(id));
    }
    return results;
  }

  /// Delete a result by ID
  Future<void> deleteResult(String id) async {
    await _db.deleteResult(id);
  }

  /// Check if a result exists
  Future<bool> hasResult(String id) async {
    return await _db.hasResult(id);
  }
}
