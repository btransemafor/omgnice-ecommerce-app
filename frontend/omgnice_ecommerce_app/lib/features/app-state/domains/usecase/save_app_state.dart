import 'package:omgnice_ecommerce_app/features/app-state/domains/entities/app_state_entity.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/repositories/app_state_repository.dart';

class SaveAppState {
  final AppStateRepository repository;

  SaveAppState({ required this.repository});

  Future<void> setAppState(AppStateEntity appStateEntity) async {
    await repository.setAppState(appStateEntity);
  }
}