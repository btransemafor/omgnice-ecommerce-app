import 'dart:convert';
import 'package:omgnice_ecommerce_app/features/app-state/data/models/app_state_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppStateLocalDatasource {
  Future<void> setAppState(AppStateModel appState);
  Future<AppStateModel> getAppState();
  Future<void> clearAppState();
}

class AppStateLocalImpl implements AppStateLocalDatasource {
  final SharedPreferences sharedPreferences;
  static const String APP_STATE_KEY = 'app_state';

  const AppStateLocalImpl(this.sharedPreferences);

  @override
  Future<void> setAppState(AppStateModel appState) async {
    await sharedPreferences.setString(APP_STATE_KEY, json.encode(appState.toJson()));
  }

  @override
  Future<AppStateModel> getAppState() async {
    final jsonString = sharedPreferences.getString(APP_STATE_KEY);
    if (jsonString != null) {
      return AppStateModel.fromJson(json.decode(jsonString));
    } else {
      return AppStateModel(
        isInitialized: false,
        isLoggedIn: false,
        isOnboardingCompleted: false,
        selectedTab: 0 
      );
    }
  }

  @override
  Future<void> clearAppState() async {
    await sharedPreferences.remove('app_state');
  }
}
