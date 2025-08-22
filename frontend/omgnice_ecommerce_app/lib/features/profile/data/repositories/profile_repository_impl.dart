import 'package:file_picker/file_picker.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/profile/data/sources/remotes/profile_remote_datasource.dart';
import 'package:omgnice_ecommerce_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  const ProfileRepositoryImpl({required this.profileDataSource});
  @override
  Future<UserEntity> getUserProfile() async {
    return await profileDataSource.getProfile();
  }

  @override
  Future<UserEntity> updateUserProfile(UserEntity user, [bool? isAdd]) async {
    // COnvert to model
    final userModel = UserModel(
      isActive: user.isActive,
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatar: user.avatar,
    );
    return await profileDataSource.updateProfile(userModel);
  }

  @override
  Future<bool> contactUs(
      Map<String, String> data, PlatformFile? attachment) async {
    return await profileDataSource.contactUs(data, attachment);
  }
}
