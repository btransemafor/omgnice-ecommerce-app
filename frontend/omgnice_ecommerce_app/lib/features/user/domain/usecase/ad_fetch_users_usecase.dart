import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/repositories/user_repository.dart';

class AdFetchUsersUsecase {
  final UserRepository userRepository;  
  AdFetchUsersUsecase({required this.userRepository}); 
  Future<List<UserEntity>> call() async {
    return await userRepository.fetchAllUser(); 
  }
}