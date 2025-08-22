import 'package:omgnice_ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository authRepository;

  const ForgotPasswordUsecase({required this.authRepository});

  Future<bool> forgotPassword(String email) async {
    try {
      print("Request Forgot PW Processing .............");
      return await authRepository.forgotPassword(email);
    }
    catch(error) {
      throw Exception(error);
    }
  }
}