import 'package:omgnice_ecommerce_app/features/app-state/domains/entities/app_state_entity.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/repositories/app_state_repository.dart';

class GetAppState {
  final AppStateRepository appStateRepository;
  const GetAppState({required this.appStateRepository});

  Future<AppStateEntity> call() async {
    return await appStateRepository.getAppState();
  }
}