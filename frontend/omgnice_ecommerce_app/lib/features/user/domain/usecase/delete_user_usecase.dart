import 'package:omgnice_ecommerce_app/features/user/domain/repositories/user_repository.dart';

class DeleteUserUsecase {
  final UserRepository userRepository;
  const DeleteUserUsecase({required this.userRepository});

  Future<bool> call([String? user_id]) async {
    print("Attempting to delete user. user_id: ehhhhe $user_id");
    return userRepository.deteleUser(user_id);
  }
}
