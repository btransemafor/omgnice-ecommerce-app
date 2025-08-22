import 'package:omgnice_ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUsecase {
  final AuthRepository authRepository;
  const ResendOtpUsecase({required this.authRepository});

  Future<bool> resendOTPVerify(String email) async {
    try {
      return await authRepository.resendOTPVerify(email);
    } catch (error) {
      rethrow;
    }
  }
}
