// ignore_for_file: avoid_print

import 'package:file_picker/file_picker.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/profile/domain/usecases/contact_us_usecase.dart';
import 'package:omgnice_ecommerce_app/features/profile/domain/usecases/update_info_usecase.dart';
import 'package:flutter/material.dart';
class ProfileProvider extends ChangeNotifier {
  final UpdateInfoUsecase updateInfoUsecase;
  final ContactUsUsecase contactUsUsecase;

  ProfileProvider(
      {required this.updateInfoUsecase, required this.contactUsUsecase});
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserEntity? _userUpdatedData;
  UserEntity? get userUpdatedData => _userUpdatedData;

  Future<void> updateProfile(UserEntity userData, [bool? isAdd]) async {
    print("Bắt đầu update thông tin user $userData");
    _isLoading = true;
    notifyListeners();
    try {
      _userUpdatedData = await updateInfoUsecase.execute(userData, isAdd);
      if (_userUpdatedData != null) {
        _isSuccess = true;
        _errorMessage = null;
      } else {
        _isSuccess = false;
      }
    } catch (error) {
      _isSuccess = false;
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Contact form submission method
  Future<bool> submitContactForm({
    required String fullName,
    required String phoneNumber,
    required String message,
    String? email,
    String? subject,
    String? orderCode,
    PlatformFile? attachment,
  }) async {
    print("Submitting contact form for $fullName");
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create data map based on the structure expected by ContactUsUsecase
      final Map<String, String> contactData = {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'message': message,
        if (email != null && email.isNotEmpty) 'email': email,
        if (subject != null && subject.isNotEmpty) 'subject': subject,
        if (orderCode != null && orderCode.isNotEmpty) 'orderCode': orderCode,
        // Add timestamp for tracking
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Call the contact us usecase with the data map and attachment
      final result = await contactUsUsecase.call(contactData, attachment);

      _isSuccess = result;
      return result;
    } catch (error) {
      _isSuccess = false;
      _errorMessage = error.toString();
      print("Contact form error: $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
