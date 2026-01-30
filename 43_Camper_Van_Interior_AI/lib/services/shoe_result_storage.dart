import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/camper_ai_config.dart';

class LaundryResultStorage {
  static const _keyPrefix = 'camper_result_';
  static const _indexKey = 'camper_results_index';

  Future<String> saveResult(CamperAIConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // Save Data
    final key = '$_keyPrefix$id';
    await prefs.setString(key, jsonEncode(config.toJson()));

    // Update Index
    final ids = prefs.getStringList(_indexKey) ?? [];
    ids.add(id);
    await prefs.setStringList(_indexKey, ids);

    return id;
  }

  Future<CamperAIConfig?> loadResult(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$id';
    final jsonStr = prefs.getString(key);
    if (jsonStr == null) return null;
    return CamperAIConfig.fromJson(jsonDecode(jsonStr));
  }

  Future<List<CamperAIConfig>> loadAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_indexKey) ?? [];
    final results = <CamperAIConfig>[];

    for (final id in ids) {
      final res = await loadResult(id);
      if (res != null) results.add(res);
    }
    // Sort by timestamp desc
    results.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return results;
  }

  Future<void> deleteResult(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$id';
    await prefs.remove(key);

    final ids = prefs.getStringList(_indexKey) ?? [];
    ids.remove(id);
    await prefs.setStringList(_indexKey, ids);
  }
}
