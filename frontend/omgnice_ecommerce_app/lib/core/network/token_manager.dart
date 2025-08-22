// lib/core/network/token_manager.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static String? _accessToken;
  static String? _refreshToken;

  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveTokens(String access, String refresh) async {
    _accessToken = access;
    _refreshToken = refresh;

    print('TOKEN: $_accessToken'); 
    print('Refresh_TOKEN: $_refreshToken'); 
    await _storage.write(key: 'accessToken', value: access);
    await _storage.write(key: 'refreshToken', value: refresh);
  }

  static Future<void> loadTokensFromStorage() async {
    _accessToken = await _storage.read(key: 'accessToken');
    _refreshToken = await _storage.read(key: 'refreshToken');
  }

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;

  static Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.deleteAll();
  }

  static Future<String?> getAccessToken() async {
  if (_accessToken != null) return _accessToken;
  _accessToken = await _storage.read(key: 'accessToken');
  return _accessToken;
}

static Future<String?> getRefreshToken() async {
  if (_refreshToken != null) return _refreshToken;
  _refreshToken = await _storage.read(key: 'refreshToken');
  return _refreshToken;
}

}



