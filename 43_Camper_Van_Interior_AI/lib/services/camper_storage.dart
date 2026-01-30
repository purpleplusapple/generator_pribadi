// lib/services/camper_storage.dart
// Storage service for individual CamperConfig results

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // It was missing in the read? Or used via PrefsService?
// The previous code had `_prefs` undefined in `loadResults` but `_db` in `saveResult`.
// It looks like I read a mix of code or the file was buggy/half-refactored in source?
// Let's look at the previous read again.
// It had `_db` usage in saveResult, but `_prefs` in loadResults. And `_keyPrefix` undefined.
// This suggests the source code was messy or I missed something.
// I will rewrite it to use `SharedPreferences` directly for simplicity as per "Camper Room" logic memory (JSON strings).

import '../model/camper_config.dart';

class CamperResultStorage {
  static const String _keyPrefix = 'camper_result_';

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  /// Generate unique ID based on timestamp
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save a CamperConfig and return its unique ID
  Future<String> saveResult(CamperConfig config) async {
    final id = _generateId();
    final prefs = await _prefs;
    final key = '$_keyPrefix$id';
    await prefs.setString(key, jsonEncode(config.toJson()));
    return id;
  }

  /// Load a CamperConfig by ID
  Future<CamperConfig?> loadResult(String id) async {
    final prefs = await _prefs;
    final key = '$_keyPrefix$id';
    final json = prefs.getString(key);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return CamperConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Load multiple CamperConfig results by ID
  Future<List<CamperConfig?>> loadResults(List<String> ids) async {
    final prefs = await _prefs;
    return ids.map((id) {
      final key = '$_keyPrefix$id';
      final json = prefs.getString(key);

      if (json == null) return null;

      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return CamperConfig.fromJson(map);
      } catch (e) {
        return null;
      }
    }).toList();
  }

  /// Delete a result by ID
  Future<void> deleteResult(String id) async {
    final prefs = await _prefs;
    final key = '$_keyPrefix$id';
    await prefs.remove(key);
  }
}
