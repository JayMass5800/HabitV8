import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing SharedPreferences access across the app
///
/// This service provides a centralized way to access SharedPreferences,
/// reducing boilerplate and making it easier to mock for testing.
///
/// Usage:
/// ```dart
/// // Set a value
/// await PreferencesService.setString('key', 'value');
///
/// // Get a value
/// final value = await PreferencesService.getString('key');
///
/// // Get the instance directly for batch operations
/// final prefs = await PreferencesService.instance;
/// await prefs.setString('key1', 'value1');
/// await prefs.setString('key2', 'value2');
/// ```
class PreferencesService {
  static SharedPreferences? _instance;

  /// Get the SharedPreferences instance
  ///
  /// This will initialize SharedPreferences on first call and cache it
  /// for subsequent calls.
  static Future<SharedPreferences> get instance async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Reset the cached instance (useful for testing)
  static void reset() {
    _instance = null;
  }

  // String operations
  /// Get a string value from preferences
  static Future<String?> getString(String key) async {
    final prefs = await instance;
    return prefs.getString(key);
  }

  /// Set a string value in preferences
  static Future<bool> setString(String key, String value) async {
    final prefs = await instance;
    return prefs.setString(key, value);
  }

  // Int operations
  /// Get an integer value from preferences
  static Future<int?> getInt(String key) async {
    final prefs = await instance;
    return prefs.getInt(key);
  }

  /// Set an integer value in preferences
  static Future<bool> setInt(String key, int value) async {
    final prefs = await instance;
    return prefs.setInt(key, value);
  }

  // Bool operations
  /// Get a boolean value from preferences
  static Future<bool?> getBool(String key) async {
    final prefs = await instance;
    return prefs.getBool(key);
  }

  /// Set a boolean value in preferences
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await instance;
    return prefs.setBool(key, value);
  }

  // Double operations
  /// Get a double value from preferences
  static Future<double?> getDouble(String key) async {
    final prefs = await instance;
    return prefs.getDouble(key);
  }

  /// Set a double value in preferences
  static Future<bool> setDouble(String key, double value) async {
    final prefs = await instance;
    return prefs.setDouble(key, value);
  }

  // StringList operations
  /// Get a list of strings from preferences
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await instance;
    return prefs.getStringList(key);
  }

  /// Set a list of strings in preferences
  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await instance;
    return prefs.setStringList(key, value);
  }

  // Remove operations
  /// Remove a key from preferences
  static Future<bool> remove(String key) async {
    final prefs = await instance;
    return prefs.remove(key);
  }

  /// Clear all preferences
  static Future<bool> clear() async {
    final prefs = await instance;
    return prefs.clear();
  }

  /// Check if a key exists in preferences
  static Future<bool> containsKey(String key) async {
    final prefs = await instance;
    return prefs.containsKey(key);
  }

  /// Get all keys in preferences
  static Future<Set<String>> getKeys() async {
    final prefs = await instance;
    return prefs.getKeys();
  }

  // Convenience methods with default values

  /// Get a string with a default value if not found
  static Future<String> getStringOrDefault(
    String key,
    String defaultValue,
  ) async {
    final value = await getString(key);
    return value ?? defaultValue;
  }

  /// Get an int with a default value if not found
  static Future<int> getIntOrDefault(String key, int defaultValue) async {
    final value = await getInt(key);
    return value ?? defaultValue;
  }

  /// Get a bool with a default value if not found
  static Future<bool> getBoolOrDefault(String key, bool defaultValue) async {
    final value = await getBool(key);
    return value ?? defaultValue;
  }

  /// Get a double with a default value if not found
  static Future<double> getDoubleOrDefault(
    String key,
    double defaultValue,
  ) async {
    final value = await getDouble(key);
    return value ?? defaultValue;
  }

  /// Get a string list with a default value if not found
  static Future<List<String>> getStringListOrDefault(
    String key,
    List<String> defaultValue,
  ) async {
    final value = await getStringList(key);
    return value ?? defaultValue;
  }
}
