// lib/services/hotel_result_storage.dart
// Storage service for individual HotelAIConfig results

import 'dart:convert';
import '../model/hotel_ai_config.dart';
import 'preferences_service.dart';

class HotelResultStorage {
  static const String _keyPrefix = 'hotel_result_';

  final PreferencesService _prefs = PreferencesService.instance;

  /// Generate unique ID based on timestamp
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save a HotelAIConfig and return its unique ID
  Future<String> saveResult(HotelAIConfig config) async {
    final id = _generateId();
    final key = '$_keyPrefix$id';
    final json = jsonEncode(config.toJson());

    await _prefs.setString(key, json);
    return id;
  }

  /// Load a HotelAIConfig by ID
  Future<HotelAIConfig?> loadResult(String id) async {
    final key = '$_keyPrefix$id';
    final json = _prefs.getString(key);

    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return HotelAIConfig.fromJson(map);
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
