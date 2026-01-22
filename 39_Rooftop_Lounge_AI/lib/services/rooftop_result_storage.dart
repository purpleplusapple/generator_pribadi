// lib/services/rooftop_result_storage.dart
// Storage service for individual RooftopConfig results

import 'dart:convert';
import '../model/rooftop_config.dart';
import 'database_service.dart';

class RooftopResultStorage {
  final DatabaseService _db = DatabaseService.instance;

  /// Generate unique ID based on timestamp
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save a RooftopConfig and return its unique ID
  Future<String> saveResult(RooftopConfig config) async {
    final id = _generateId();
    await _db.insertResult(id, config.toJson());
    return id;
  }

  /// Load a RooftopConfig by ID
  Future<RooftopConfig?> loadResult(String id) async {
    final map = await _db.getResult(id);
    if (map == null) return null;

    try {
      return RooftopConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Load multiple RooftopConfig results by ID
  Future<List<RooftopConfig?>> loadResults(List<String> ids) async {
    return ids.map((id) {
      final key = '$_keyPrefix$id';
      final json = _prefs.getString(key);

      if (json == null) return null;

      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return RooftopConfig.fromJson(map);
      } catch (e) {
        return null;
      }
    }).toList();
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
