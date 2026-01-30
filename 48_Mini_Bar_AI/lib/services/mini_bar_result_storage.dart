// lib/services/mini_bar_result_storage.dart
// Storage service for Mini Bar AI results using SharedPreferences

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/mini_bar_config.dart';

class MiniBarResultStorage {
  static const _keyPrefix = 'minibar_result_';
  static const _indexKey = 'minibar_results_index';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Save a result and return its unique ID
  Future<String> saveResult(MiniBarConfig config) async {
    final prefs = await _prefs;
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // Save the individual config
    await prefs.setString('$_keyPrefix$id', jsonEncode(config.toJson()));

    // Update the index list
    final List<String> index = prefs.getStringList(_indexKey) ?? [];
    if (!index.contains(id)) {
      index.insert(0, id); // Newest first
      await prefs.setStringList(_indexKey, index);
    }

    return id;
  }

  /// Get all saved results
  Future<List<MiniBarConfig>> getAllResults() async {
    final prefs = await _prefs;
    final List<String> index = prefs.getStringList(_indexKey) ?? [];
    final List<MiniBarConfig> results = [];

    for (final id in index) {
      final String? jsonStr = prefs.getString('$_keyPrefix$id');
      if (jsonStr != null) {
        try {
          results.add(MiniBarConfig.fromJson(jsonDecode(jsonStr)));
        } catch (e) {
          // Skip corrupted entries
          print('Error parsing result $id: $e');
        }
      }
    }

    return results;
  }

  /// Delete a result
  Future<void> deleteResult(String id) async {
    final prefs = await _prefs;
    await prefs.remove('$_keyPrefix$id');

    final List<String> index = prefs.getStringList(_indexKey) ?? [];
    index.remove(id);
    await prefs.setStringList(_indexKey, index);
  }
}
