import 'package:omgnice_ecommerce_app/features/app-state/data/models/app_state_model.dart';
import 'package:omgnice_ecommerce_app/features/app-state/data/sources/app_state_local_datasource.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/repositories/app_state_repository.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/entities/app_state_entity.dart';

class AppStateRepositoryImp implements AppStateRepository {
  final AppStateLocalDatasource appStateLocalDatasource;
  const AppStateRepositoryImp(this.appStateLocalDatasource);

  @override
  Future<void> clearAppState() async {
    await appStateLocalDatasource.clearAppState();
  }

  @override
  Future<AppStateEntity> getAppState() async {
    return await appStateLocalDatasource.getAppState();
  }

  @override
  Future<void> setAppState(AppStateEntity appStateEntity) async {
    final stateModel = AppStateModel(
      isInitialized: appStateEntity.isInitialized,
      isLoggedIn: appStateEntity.isLoggedIn,
      isOnboardingCompleted: appStateEntity.isOnboardingCompleted,
      selectedTab: 0
    );
    await appStateLocalDatasource.setAppState(stateModel);
  }
}
