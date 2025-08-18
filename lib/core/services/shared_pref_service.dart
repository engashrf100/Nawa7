import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  final SharedPreferences _prefs;

  SharedPrefService(this._prefs);

  /// ✅ Save String
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// ✅ Get String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// ✅ Save Object (Automatically convert to JSON)
  Future<void> saveObject(String key, Map<String, dynamic> json) async {
    await _prefs.setString(key, jsonEncode(json));
  }

  /// ✅ Get Object (Return Map)
  Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// ✅ Delete
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// ✅ Clear all (if needed)
  Future<void> clear() async {
    await _prefs.clear();
  }
}
