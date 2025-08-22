import 'package:omgnice_ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class CheckPasswordUsecase {
  final AuthRepository authRepository; 
  const CheckPasswordUsecase({required this.authRepository});

  Future<bool> call(String currentPassword) async {
    return await authRepository.checkPassword(currentPassword); 
  }
}