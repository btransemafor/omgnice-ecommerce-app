import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/auth/auth_export.dart';

class SigninGoogleUsecase {
  final AuthRepository authRepository; 
  const SigninGoogleUsecase({required this.authRepository}); 

  Future<UserEntity?> call() async {
    return await authRepository.signInWithGoogle();  
  }
}