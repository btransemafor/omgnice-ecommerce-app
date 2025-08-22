import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/auth/auth_export.dart';

abstract class AuthRepository {
  //Future<String> loginWithPhone(String phone, String password);
  Future<LoginStatus> loginWithEmail(String email, String password);
  Future<UserEntity?> signInWithGoogle();
  
  Future<bool> register(String email, String phone, String password);
  //Future<bool>verifyOTP(String otp);
  Future<bool> verifyOTP(String email, String otp);
  // Resend OTP
  Future<bool> resendOTPVerify(String email);
  Future<bool> forgotPassword(String email);
  Future<bool> resetPassword(String? email, String newPassword); // có thể không cần email nếu user muốn đổi pass trong lúc đã đăng nhập. 
  Future<void> logout();

  // Feature getDataUser from SharedPreference 
  Future<UserEntity> getCurrentUser(); 
  Future<bool> checkGoogleEmailExists(String idToken);
  Future<bool> checkPassword(String currentPassword); 
  
}
