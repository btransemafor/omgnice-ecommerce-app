// login_user_usecase.dart

/* 
UseCase là business logic (nghiệp vụ) của ứng dụng.

Nó không quan tâm đến dữ liệu đến từ đâu (API, Database, Firebase...).

Gọi đến AuthRepository để lấy dữ liệu, xử lý nghiệp vụ trước khi trả kết quả về.
*/
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/auth_provider.dart';
import '../repositories/auth_repository.dart'; // Lien ket Data Layer

class LoginUserUseCase {
  final AuthRepository authRepository;

  LoginUserUseCase(this.authRepository);

/*   Future<String> execute(String phone, String password) async {
    try {
      return await authRepository.loginWithPhone(phone, password);
    } catch (e) {
      print("Login use case error: $e");
      rethrow;
    }
  } */

  Future<LoginStatus> loginWithEmail(String email, String password) async {
    try {
      final result = await authRepository.loginWithEmail(email, password);

      if (result == LoginStatus.requireVerification) {
        return LoginStatus.requireVerification;
      } else if (result == LoginStatus.failed) {
        return LoginStatus.failed;
      } else {
        return LoginStatus.success;
      }
    } catch (e) {
      print("Login use case error: $e");
      return LoginStatus.failed;
    }
  }
}
