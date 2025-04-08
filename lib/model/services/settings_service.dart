import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService._internal();
  static final SettingsService instance = SettingsService._internal();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<T?> getValue<T>(String key) async {
    final sharedPrefs = await prefs;
    if (T == bool) return sharedPrefs.getBool(key) as T?;
    if (T == String) return sharedPrefs.getString(key) as T?;
    if (T == int) return sharedPrefs.getInt(key) as T?;
    if (T == double) return sharedPrefs.getDouble(key) as T?;
    if (T == List<String>) return sharedPrefs.getStringList(key) as T?;
    return null;
  }

  Future<void> setValue<T>(String key, T value) async {
    final sharedPrefs = await prefs;
    if (value is bool) await sharedPrefs.setBool(key, value);
    if (value is String) await sharedPrefs.setString(key, value);
    if (value is int) await sharedPrefs.setInt(key, value);
    if (value is double) await sharedPrefs.setDouble(key, value);
    if (value is List<String>) await sharedPrefs.setStringList(key, value);
    if (value is List<Map<String, Object>>) {
      final jsonString = jsonEncode(value);
      await sharedPrefs.setString(key, jsonString);
    }
  }

  Future<List<Map<String, Object>>?> getHousehold() async {
    final sharedPrefs = await prefs;
    final householdString = sharedPrefs.getString('household');
    if (householdString != null) {
      final List<dynamic> decoded = jsonDecode(householdString);
      return decoded.map((e) => Map<String, Object>.from(e)).toList();
    }
    return null;
  }
}