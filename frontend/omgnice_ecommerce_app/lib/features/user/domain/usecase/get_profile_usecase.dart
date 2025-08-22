import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/repositories/user_repository.dart';

class GetProfileUsecase {
  final UserRepository userRepository;
  const GetProfileUsecase({required this.userRepository});

  Future<UserEntity> call([String? user_id]) async {
    return userRepository.getProfileUser(user_id);
  }
}
