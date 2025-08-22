// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/entities/userStats.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/ad_fetch_users_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/delete_user_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/fetch_statistics_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/get_profile_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/update_point_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/update_user_usecase.dart';

class UserProvider extends ChangeNotifier {
  final FetchStatisticsUsecase fetchStatisticsUsecase;
  final UpdateUserUsecase updateUserUsecase;
  final GetProfileUsecase getProfileUsecase;
  final AdFetchUsersUsecase adFetchUsersUsecase;
  final UpdateUserPointUseCase updateUserPointUseCase;
  final DeleteUserUsecase deleteUserUsecase;

  UserProvider(
      {required this.fetchStatisticsUsecase,
      required this.updateUserUsecase,
      required this.getProfileUsecase,
      required this.adFetchUsersUsecase,
      required this.updateUserPointUseCase,
      required this.deleteUserUsecase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserEntity? _user;
  UserEntity? get user => _user;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  Userstats? _stats;
  Userstats? get stats => _stats;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess; // Sửa typo: isSucess -> isSuccess

  // Admin - Fetch List User
  List<UserEntity> _users = [];
  List<UserEntity> get users => _users;

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _errorMessage = '';
    _isSuccess = false;
    notifyListeners();

    try {
      final result = await adFetchUsersUsecase.call();
      print('Fetch result: $result');

      if (result != null && result.isNotEmpty) {
        _users = List<UserEntity>.from(result);
        // Validate each UserEntity to ensure it has required fields
        _users = _users.where((user) {
          bool isValid =
              user.id != null && user.name != null && user.phone != null;
          if (!isValid) {
            print('Invalid user found: $user');
          }
          return isValid;
        }).toList();
        _isSuccess = _users.isNotEmpty;
        if (!_isSuccess) {
          _errorMessage = 'No valid users found after filtering';
        }
      } else {
        _users = [];
        _isSuccess = false;
        _errorMessage = 'No users retrieved from the server';
      }
    } catch (error) {
      _errorMessage = 'Failed to fetch users: ${error.toString()}';
      _users = [];
      _isSuccess = false;
      print("Error fetching users: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStatisticUser(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await fetchStatisticsUsecase.call(userId);
      _stats = result;
      print("Loaded stats: ${_stats?.totalQuantityOrder}");
    } catch (e) {
      _errorMessage = 'Failed to load user statistics: $e';
      _stats = null;
      print("Error: $_errorMessage");
    }

    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _stats = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserInfo(Map<String, String> updateData,
      [String? user_id]) async {
    _isLoading = true;
    notifyListeners();
    try {
      _isSuccess = await updateUserUsecase.call(updateData, user_id);
      _errorMessage = '';
      return _isSuccess;
    } catch (e) {
      _errorMessage = 'Update failed: $e';
      print("Update failed: $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProfileUser([String? user_id]) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await getProfileUsecase.call(user_id);
      print("User profile fetched: ${_user?.point}");
    } catch (error) {
      print("Error fetching user profile: $error");
      _errorMessage = 'Unable to load user profile';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tìm user theo id
  UserEntity? filterUserById(String userId) {
    try {
      _user = users.firstWhere((user) => user.id == userId);
      return _user;
    } catch (e) {
      // Không tìm thấy user
      debugPrint('Không tìm thấy user với id: $userId');
      return null;
    }
  }

  ///  Gọi khi cần cộng/trừ điểm
  Future<bool> updatePoint(int amount) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await updateUserPointUseCase.call(amount);
      if (success) {
        //  await loadProfile(); // Cập nhật lại thông tin
      }
      return success;
    } catch (e) {
      print("Error updating point: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ----- DELETE USER ----------- //
  Future<bool> deleteUser([String? user_id]) async {


    _isLoading = true;
    notifyListeners();
    print('Tôi đang xóa user có id là : '+ user_id.toString()); 
    try {
      final isSuccess = await deleteUserUsecase.call(user_id);
      return isSuccess;
    } catch (e) {
      print("Error updating point: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
