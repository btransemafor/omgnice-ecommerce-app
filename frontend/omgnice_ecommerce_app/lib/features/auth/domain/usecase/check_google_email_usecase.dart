import 'package:omgnice_ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class CheckGoogleEmailUsecase {
  final AuthRepository repository;

  CheckGoogleEmailUsecase(this.repository);

  Future<bool> call(String idToken) async{
    return await repository.checkGoogleEmailExists(idToken);
  }
}
