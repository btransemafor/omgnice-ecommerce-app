import 'package:file_picker/file_picker.dart';
import 'package:omgnice_ecommerce_app/features/profile/domain/repositories/profile_repository.dart';
class ContactUsUsecase {
  final ProfileRepository profileRepository; 
  const ContactUsUsecase({required this.profileRepository}); 

  Future<bool> call(Map<String, String> data, PlatformFile? attachment) async  {
    return await profileRepository.contactUs(data, attachment); 
  }
}