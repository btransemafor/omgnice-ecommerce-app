import '../entities/app_state_entity.dart'; 
abstract class AppStateRepository {
  Future<AppStateEntity> getAppState(); 
  Future<void> setAppState(AppStateEntity appStateEntity);
  Future<void> clearAppState();
}