// lib/core/providers/user_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/models/user_model.dart';

class UserProvider1 extends ChangeNotifier {
  UserModel? _user;
  final _storage = const FlutterSecureStorage();
  final _userKey = 'app_user';

  UserModel? get user => _user;

  /// Đặt user hiện tại và lưu vào local
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
    _saveUserToStorage(user);
  }

  /// Xóa user khi logout
  void clearUser() async {
    _user = null;
    notifyListeners();
    await _storage.delete(key: _userKey);
  }

  /// Gọi khi app khởi động → load user từ local
  Future<void> loadUserFromStorage() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson);
        _user = UserModel.fromJson(userMap);
        notifyListeners();
      } catch (_) {
        await _storage.delete(key: _userKey);
      }
    }
  }

  /// Lưu user vào secure local storage
  Future<void> _saveUserToStorage(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: userJson);
  }
}
