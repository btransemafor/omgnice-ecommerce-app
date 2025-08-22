import 'package:omgnice_ecommerce_app/features/app-state/data/sources/app_state_local_datasource.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/usecase/get_app_state.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/usecase/save_app_state.dart';
import 'package:omgnice_ecommerce_app/features/app-state/representation/managers/app_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omgnice_ecommerce_app/features/app-state/data/repositories/app_state_repository_imp.dart';

class AppStateProvider {
  static Future<ChangeNotifierProvider> getProviders() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Dependency Injection
    final localDataSource = AppStateLocalImpl(sharedPreferences);
    final repository = AppStateRepositoryImp(localDataSource);
    final getAppState = GetAppState(appStateRepository: repository);
    final saveAppState = SaveAppState(repository: repository);

    return ChangeNotifierProvider<AppStateManager>(
      create: (_) => AppStateManager(
        getAppStateUseCase:getAppState ,
         saveAppStateUseCase: saveAppState)..initializeAppState()) ;
  }
}
