import 'dart:convert';
import 'package:omgnice_ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();

  Future<void> cacheToken(String access, String refresh);
  
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clear();
}


class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.prefs);

  static const _userKey = 'auth_user';
  static const _accessKey = 'auth_accessToken';
  static const _refreshKey = 'auth_refreshToken';

  @override
  Future<void> cacheUser(UserModel user) async {
    print("user.pwRandom: HEHEHHEHEHEHHE${user.pwRandom}");
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    print("User cached successfully: ${user.toJson()}");
    print("User cached successfully: ${user.pwRandom}");
    print("User cached successfully: ${user.id}");
    print("User cached successfully: ${user.name}");
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonStr = prefs.getString(_userKey);
    if (jsonStr == null) return null;
    print("User cached successfully: $jsonStr");
    print("User cached successfully: ${jsonDecode(jsonStr)}");
    return UserModel.fromJson(jsonDecode(jsonStr));
  }

  @override
  Future<void> cacheToken(String access, String refresh) async {
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
  }

  @override
  Future<String?> getAccessToken() => Future.value(prefs.getString(_accessKey));
  @override
  Future<String?> getRefreshToken() => Future.value(prefs.getString(_refreshKey));

  @override
  Future<void> clear() async {
    await prefs.remove(_userKey);
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove(_userKey); 
  }

}

