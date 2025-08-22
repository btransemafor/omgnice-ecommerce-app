// ignore_for_file: avoid_print, avoid_init_to_null

import 'package:flutter/foundation.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/get_current_user_usecase.dart';

class UserProvider extends ChangeNotifier {
  final GetCurrentUserUsecase getCurrentUserUsecase;
  UserProvider({required this.getCurrentUserUsecase});

  UserEntity? _userInfo;
  UserEntity? get userInfo => _userInfo;

  int? _role = null; // user 
  int? get role => _role; 

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    try {
      _isLoading = true;
      notifyListeners();

      _userInfo = await getCurrentUserUsecase.call();


      print('Gọi user usecase  thành công $_userInfo');

      print('Avatar URL = ...${userInfo!.pwRandom}<|cursor|>') ;
    } catch (e) {

       print('[UserProvider] Lỗi khi loadUser: $e');
      _userInfo = null;

    } finally {

      _isLoading = false;
      // Get role 
      _role = _userInfo!.roleId ?? 1 ; 
      notifyListeners();
    }
  }

  void clearUser() {
    _userInfo = null;
    notifyListeners();
  }
}
