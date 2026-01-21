// lib/services/beauty_salon_result_storage.dart
// Storage service for individual BeautySalonAIConfig results

import 'dart:convert';
import '../model/beauty_salon_ai_config.dart';
import 'preferences_service.dart';

class BeautySalonResultStorage {
  static const String _keyPrefix = 'beauty_salon_result_';

  final PreferencesService _prefs = PreferencesService.instance;

  /// Generate unique ID based on timestamp
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save a BeautySalonAIConfig and return its unique ID
  Future<String> saveResult(BeautySalonAIConfig config) async {
    final id = _generateId();
    final key = '$_keyPrefix$id';
    final json = jsonEncode(config.toJson());

    await _prefs.setString(key, json);
    return id;
  }

  /// Load a BeautySalonAIConfig by ID
  Future<BeautySalonAIConfig?> loadResult(String id) async {
    final key = '$_keyPrefix$id';
    final json = _prefs.getString(key);

    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return BeautySalonAIConfig.fromJson(map);
    } catch (e) {
      return null;
    }
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
