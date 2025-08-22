
import 'package:omgnice_ecommerce_app/features/home/home.dart';

class CheckSpinPermissionUseCase {
  final HomeRepository repository;

  CheckSpinPermissionUseCase(this.repository);

  Future<bool> call() {
    return repository.canSpinToday(); 
  }
}
