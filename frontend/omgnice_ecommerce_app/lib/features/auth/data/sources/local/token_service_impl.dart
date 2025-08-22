import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenService {
  Future<void> storeAccessToken(String token);
  Future<void> storeRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}

class TokenServiceImpl implements TokenService {
  final SharedPreferences prefs;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  TokenServiceImpl(this.prefs);

  @override
  Future<void> storeAccessToken(String token) async {
    try {
       await prefs.setString(_accessTokenKey, token);
       print("Access token stored successfully: $token");
    }
    catch (e) {
      print("Error storing access token: $e");
    }
   
  }

  @override
  Future<void> storeRefreshToken(String token) async {
    await prefs.setString(_refreshTokenKey, token);
  }

  @override
  Future<String?> getAccessToken() async {
    return prefs.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
