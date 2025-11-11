import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const _tokenKey = 'auth_token';
  static const _rememberMeKey = 'remember_me';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  AuthStorageService(this._secureStorage, this._prefs);

  // Token operations - using SharedPreferences as fallback for macOS issues
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      // Fallback to SharedPreferences if secure storage fails
      await _prefs.setString(_tokenKey, token);
    }
  }

  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      // Fallback to SharedPreferences
      return _prefs.getString(_tokenKey);
    }
  }

  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
    } catch (e) {
      // Fallback to SharedPreferences
      await _prefs.remove(_tokenKey);
    }
  }

  // Remember me operations
  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(_rememberMeKey, value);
  }

  Future<bool> getRememberMe() async {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      // Ignore secure storage errors
    }
    await _prefs.clear();
  }
}
