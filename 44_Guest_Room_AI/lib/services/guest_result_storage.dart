// lib/services/guest_result_storage.dart
// Storage service for individual GuestAIConfig results

import 'dart:convert';
import '../model/guest_ai_config.dart';
import 'database_service.dart';

class GuestResultStorage {
  final DatabaseService _db = DatabaseService.instance;

  /// Generate unique ID based on timestamp
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save a GuestAIConfig and return its unique ID
  Future<String> saveResult(GuestAIConfig config) async {
    final id = _generateId();
    await _db.insertResult(id, config.toJson());
    return id;
  }

  /// Load a GuestAIConfig by ID
  Future<GuestAIConfig?> loadResult(String id) async {
    final map = await _db.getResult(id);
    if (map == null) return null;

    try {
      return GuestAIConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Load multiple GuestAIConfig results by ID
  Future<List<GuestAIConfig?>> loadResults(List<String> ids) async {
    return ids.map((id) {
      final key = '$_keyPrefix$id';
      final json = _prefs.getString(key);

      if (json == null) return null;

      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return GuestAIConfig.fromJson(map);
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
