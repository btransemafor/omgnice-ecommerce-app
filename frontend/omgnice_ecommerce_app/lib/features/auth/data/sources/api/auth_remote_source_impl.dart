// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:omgnice_ecommerce_app/core/constants/url.dart';
import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import '../../../auth_export.dart'; 
abstract class AuthRemoteSource {
  Future<String> loginWithPhone(String phone, String password);
  Future<LoginResponseModel> loginWithEmail(String email, String password);
  Future<bool> register(String email, String phone, String password);
  Future<bool> verifyOTP(String email, String otp);
  Future<bool> resendOTPVerify(String email);
  Future<bool> forgotPassword(String email);
  Future<void> logOut(String refreshToken);
  Future<bool> resetPassword(String? email, String newPassword);
  Future<bool> checkGoogleEmailExists(String idToken);
  Future<bool> checkPassword(String currentPassword);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final Dio dio = DioClient().client;

  @override
  Future<String> loginWithPhone(String phone, String password) async {
    try {
      final response = await dio.post(
        "$baseUrl/auth/login",
        data: {
          "phone": phone,
          "password": password,
        },
      );
      return response.data["token"];
    } on DioException catch (e) {
      throw Exception(
        "Login failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }

  @override
  Future<LoginResponseModel> loginWithEmail(
      String email, String password) async {
    try {
      print("omgnicefvrrrrrrrrrrrrrrrrrrrrrrrr");
      final response = await dio.post(
        "/auth/login",
        data: {
          "email": email.trim(),
          "password": password.trim(),
        },
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];

        UserModel userInfo = UserModel(
          isActive: data['is_active'],
          id: data['id'],
          name: data['name'],
          email: data['email'],
          roleId: data['role_id'],
          phone: data['phone'],
          point: data['point'],
        );
        return LoginResponseModel(
            accessToken: data['accessToken'],
            refreshToken: data['refreshToken'],
            requireVerification: false,
            is_active: data['is_active'],
            user: userInfo);
      }

      if (response.data?['requireVerification'] == true) {
        stderr.write('${response.data['data']}');
        return LoginResponseModel(
          is_active: response.data['is_active'],
          requireVerification: true,
          message: response.data?['message'],
          userId: response.data?['userId'],
        );
      }

      throw Exception(response.data?['message'] ?? 'Đăng nhập thất bại');
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  @override
  Future<bool> checkGoogleEmailExists(String idToken) async {
    try {
      final response =
          await dio.post("/auth/google/verify", data: {"idToken": idToken});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw Exception(
        "Register failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }

  @override
  Future<bool> register(String email, String phone, String password) async {
    try {
      final response = await dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
          "phone": phone,
          "name": "guest"
        },
      );

      return response.data['success'] == true;
    } on DioException catch (e) {
      throw Exception(
        "Register failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }

  @override
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {
          "email": email,
          "otpCode": otp,
        },
      );

      final data = response.data;
     // print(data);
      return data['success'] == true;
    } on DioException catch (e) {
      throw Exception(
        "Verify OTP failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }

  @override
  Future<bool> resendOTPVerify(String email) async {
    try {
      print("Resending OTP to email: $email");
      if (email.isEmpty) {
        throw Exception("Email cannot be empty");
      }
      final response = await dio.post(
        '/auth/resend-otp-verify',
        data: {"email": email},
      );

      return response.data['success'] == true;
    } on DioException catch (e) {
      throw Exception(
        "Resend OTP failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
    //  print('Dang goi');
      final response = await dio.post(
        '/auth/send-reset-otp',
        data: {"email": email},
      );

      return response.data['success'] == true;
    } on DioException catch (e) {
      throw Exception(
        "Request Forgot password failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }

  @override
  Future<void> logOut(String refreshToken) async {
    try {
     // print(refreshToken);
      final response = await dio.delete(
        "/auth/logout",
        data: {
          "refreshToken": refreshToken,
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Logout failed: ${response.data["message"]}");
      }
      else if (response.statusCode == 200 ) {
         //  print("LOGOUT THANH CONG"); 
      }
    } on DioException catch (e) {
      throw Exception(
        "Logout failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }

  @override
  Future<bool> resetPassword(String? email, String newPassword) async {
    try {
      final response;
      String endpoint;

      // Kiểm tra nếu email có giá trị, chọn đúng endpoint
      if (email != null && email.isNotEmpty) {
        print("Reset password request for email: $email");
        endpoint = "/auth/reset-password"; // Quên mật khẩu, cần email
      } else {
        print("Reset password request for unknown email");
        endpoint = "/auth/change-password"; // Đã đăng nhập, không cần email
      }

      // Gửi yêu cầu reset mật khẩu
      response = await dio.post(
        endpoint,
        data: {
          'newPassword': newPassword,
          if (email != null) 'email': email,
        },
      );

      // Kiểm tra response
      if (response.statusCode == 200 && response.data != null) {
        return response.data['success'] == true;
      } else {
        throw Exception(
            "Failed to reset password: ${response.data['message']}");
      }
    } catch (e) {
      print("Error resetting password: $e");
      throw Exception("Reset password failed: $e");
    }
  }

  @override
  Future<bool> checkPassword(String currentPassword) async {
    try {
      final response = await dio.post('/users/checkpw', data: {
        "currentPassword": currentPassword,
      });

      return response.statusCode == 200 && response.data['success'] == true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data['message'] ?? "Lỗi không xác định";
      if (status == 400) {
        return false;
      }
      throw Exception("Check password failed: $msg");
    } catch (e) {
      throw Exception("Check password failed: $e");
    }
  }
}
