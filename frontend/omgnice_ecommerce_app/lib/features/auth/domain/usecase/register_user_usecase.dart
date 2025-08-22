import '../repositories/auth_repository.dart'; // Lien ket Data Layer

class RegisterUserUseCase {
  final AuthRepository authRepository;

  RegisterUserUseCase(this.authRepository);

  Future<bool> register(String email, String phone, String password) {
  return authRepository.register(email, phone, password);
  }
}
