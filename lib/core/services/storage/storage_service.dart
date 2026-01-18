import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for managing local storage (preferences and secure storage)
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  SharedPreferences? _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Initialize the storage service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('StorageService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }

  // ============ Shared Preferences (Non-sensitive data) ============

  /// Get string value
  String? getString(String key) => prefs.getString(key);

  /// Set string value
  Future<bool> setString(String key, String value) => prefs.setString(key, value);

  /// Get int value
  int? getInt(String key) => prefs.getInt(key);

  /// Set int value
  Future<bool> setInt(String key, int value) => prefs.setInt(key, value);

  /// Get bool value
  bool? getBool(String key) => prefs.getBool(key);

  /// Set bool value
  Future<bool> setBool(String key, bool value) => prefs.setBool(key, value);

  /// Get double value
  double? getDouble(String key) => prefs.getDouble(key);

  /// Set double value
  Future<bool> setDouble(String key, double value) => prefs.setDouble(key, value);

  /// Get string list value
  List<String>? getStringList(String key) => prefs.getStringList(key);

  /// Set string list value
  Future<bool> setStringList(String key, List<String> value) => prefs.setStringList(key, value);

  /// Remove a key
  Future<bool> remove(String key) => prefs.remove(key);

  /// Check if key exists
  bool containsKey(String key) => prefs.containsKey(key);

  /// Clear all preferences
  Future<bool> clear() => prefs.clear();

  // ============ Secure Storage (Sensitive data like tokens) ============

  /// Get secure string value
  Future<String?> getSecureString(String key) => _secureStorage.read(key: key);

  /// Set secure string value
  Future<void> setSecureString(String key, String value) => _secureStorage.write(key: key, value: value);

  /// Delete secure value
  Future<void> deleteSecure(String key) => _secureStorage.delete(key: key);

  /// Delete all secure values
  Future<void> deleteAllSecure() => _secureStorage.deleteAll();

  /// Check if secure key exists
  Future<bool> containsSecureKey(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null;
  }
}
