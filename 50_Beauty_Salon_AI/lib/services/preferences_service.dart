// lib/services/preferences_service.dart
// SharedPreferences wrapper singleton

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._();
  static final PreferencesService instance = PreferencesService._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('PreferencesService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  // StringList operations
  Future<bool> setStringList(String key, List<String> value) async {
    return prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  // Remove
  Future<bool> remove(String key) async {
    return prefs.remove(key);
  }

  // Clear all
  Future<bool> clear() async {
    return prefs.clear();
  }

  // Contains
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }
}
