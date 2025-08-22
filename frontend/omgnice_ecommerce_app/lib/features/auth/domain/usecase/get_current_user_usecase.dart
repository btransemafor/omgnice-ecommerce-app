import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
class GetCurrentUserUsecase {
  final AuthRepository authRepository; 
  const GetCurrentUserUsecase({required this.authRepository}); 
  Future<UserEntity> call() async {
    return authRepository.getCurrentUser(); 
  }
}