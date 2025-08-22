import 'package:omgnice_ecommerce_app/features/user/domain/repositories/user_repository.dart';

class UpdateUserPointUseCase {
  final UserRepository repository;

  UpdateUserPointUseCase({required this.repository});

  /// Cập nhật điểm: amount > 0 là cộng, < 0 là trừ.
  Future<bool> call(int amount) {
    return repository.updateUserPoint(amount);
  }
}
