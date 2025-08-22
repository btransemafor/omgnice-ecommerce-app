import 'package:omgnice_ecommerce_app/features/auth/data/models/user_model.dart';

class LoginResponseModel {
  final String? accessToken;
  final String? refreshToken;
  final bool requireVerification;
  final String? message;
  final String? userId;
  final UserModel? user;
  final bool is_active; 

  LoginResponseModel({
    this.accessToken,
    this.refreshToken,
    this.requireVerification = false,
    this.message,
    this.userId,
    this.user,
    required this.is_active 
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // Trường hợp thành công: có token + user
    if (json.containsKey("accessToken") && json.containsKey("refreshToken")) {
      return LoginResponseModel(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        user: UserModel.fromJson(json),
        requireVerification: false,
        is_active: json['is_active']
      );
    }

    // Trường hợp yêu cầu xác minh OTP
    if (json['requireVerification'] == true) {
      return LoginResponseModel(
        requireVerification: true,
        message: json['message'],
        userId: json['userId'],
        is_active: json['is_active']
      );
    }

    // Trường hợp lỗi không rõ → trả message
    return LoginResponseModel(
      message: json['message'] ?? 'Đăng nhập thất bại',
      is_active: json['is_active']
    );
  }
}
