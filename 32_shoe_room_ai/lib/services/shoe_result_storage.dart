// lib/services/shoe_result_storage.dart
// Storage service for individual ShoeAIConfig results

import 'dart:convert';
import '../model/shoe_ai_config.dart';
import 'database_service.dart';

class LaundryResultStorage {
  final DatabaseService _db = DatabaseService.instance;

  /// Generate unique ID based on timestamp
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save a ShoeAIConfig and return its unique ID
  Future<String> saveResult(ShoeAIConfig config) async {
    final id = _generateId();
    await _db.insertResult(id, config.toJson());
    return id;
  }

  /// Load a ShoeAIConfig by ID
  Future<ShoeAIConfig?> loadResult(String id) async {
    final map = await _db.getResult(id);
    if (map == null) return null;
    
    try {
      return ShoeAIConfig.fromJson(map);
    } catch (e) {
      return null;
    }
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
