import 'package:file_picker/file_picker.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getUserProfile();
  Future<UserEntity> updateUserProfile(UserEntity user, [bool? isAdd]);
  Future<bool> contactUs(Map<String, String> data, PlatformFile? attachment ); 
}
