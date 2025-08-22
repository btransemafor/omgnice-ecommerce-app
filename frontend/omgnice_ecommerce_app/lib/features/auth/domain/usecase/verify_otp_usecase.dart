import 'package:omgnice_ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyOTPUseCase {
  final AuthRepository authRepository;
  const VerifyOTPUseCase({required this.authRepository});
/*
  Future<bool> verifyOTP(String otp) async {
    try {
      final result = authRepository.verifyOTP(otp);
      return result;
    }
    catch(e) {
      throw Exception('Failed to verify OTP');
    }
  }
 */
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final result = await authRepository.verifyOTP(email, otp);
      return result;
    } catch (e) {
      throw Exception('Failed to verify OTP');
    }
  }
}
