// lib/services/shoe_result_storage.dart
// Storage service for individual ShoeAIConfig results

import 'dart:convert';
import '../model/shoe_ai_config.dart';
import 'preferences_service.dart';

class LaundryResultStorage {
  static const String _keyPrefix = 'shoe_result_';

  final PreferencesService _prefs = PreferencesService.instance;

  /// Generate unique ID based on timestamp
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save a ShoeAIConfig and return its unique ID
  Future<String> saveResult(ShoeAIConfig config) async {
    final id = _generateId();
    final key = '$_keyPrefix$id';
    final json = jsonEncode(config.toJson());
    
    await _prefs.setString(key, json);
    return id;
  }

  /// Load a ShoeAIConfig by ID
  Future<ShoeAIConfig?> loadResult(String id) async {
    final key = '$_keyPrefix$id';
    final json = _prefs.getString(key);
    
    if (json == null) return null;
    
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return ShoeAIConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Load multiple ShoeAIConfig results by ID
  Future<List<ShoeAIConfig?>> loadResults(List<String> ids) async {
    return ids.map((id) {
      final key = '$_keyPrefix$id';
      final json = _prefs.getString(key);

      if (json == null) return null;

      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return ShoeAIConfig.fromJson(map);
      } catch (e) {
        return null;
      }
    }).toList();
  }

  /// Delete a result by ID
  Future<void> deleteResult(String id) async {
    final key = '$_keyPrefix$id';
    await _prefs.remove(key);
  }

  /// Check if a result exists
  bool hasResult(String id) {
    final key = '$_keyPrefix$id';
    return _prefs.containsKey(key);
  }
}
