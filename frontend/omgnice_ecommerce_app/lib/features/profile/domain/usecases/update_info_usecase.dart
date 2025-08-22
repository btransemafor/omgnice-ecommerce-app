import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateInfoUsecase {
  final ProfileRepository profileRepository; 
  const UpdateInfoUsecase({required this.profileRepository}); 
  Future<UserEntity> execute(UserEntity userData, [bool? isAdd]) async {
    return await profileRepository.updateUserProfile(userData); 
  }
}