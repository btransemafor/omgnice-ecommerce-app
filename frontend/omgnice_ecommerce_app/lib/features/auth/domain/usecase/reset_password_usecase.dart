import 'package:omgnice_ecommerce_app/features/auth/auth_export.dart';

class ResetPasswordUsecase {
  final AuthRepository authRepository; 
  const ResetPasswordUsecase({required this.authRepository}); 

  Future<bool> call(String? email, String newPassword) async  {
    return await authRepository.resetPassword(email, newPassword); 
  }
}