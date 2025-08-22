import 'package:omgnice_ecommerce_app/features/user/domain/repositories/user_repository.dart';

class UpdateUserUsecase  {
  final UserRepository userRepository; 
  const UpdateUserUsecase({
    required this.userRepository 
  }); 
  Future<bool> call(Map<String,String> updateData, [String? user_id]) async {
    return userRepository.updateUser(updateData, user_id); 
  }
}