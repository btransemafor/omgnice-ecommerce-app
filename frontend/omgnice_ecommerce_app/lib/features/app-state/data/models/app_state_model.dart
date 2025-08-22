import 'package:omgnice_ecommerce_app/features/app-state/domains/entities/app_state_entity.dart';
class AppStateModel extends AppStateEntity {
  const AppStateModel({
    super.isInitialized = false,
    super.isLoggedIn = false,
    super.isOnboardingCompleted = false,
    super.selectedTab = 0 
  });

  factory AppStateModel.fromJson(Map<String, dynamic> json) {
    return AppStateModel(
      isInitialized: json['isInitialized'] as bool? ?? false,
      isLoggedIn: json['isLoggedIn'] as bool? ?? false,
      isOnboardingCompleted: json['isOnboardingCompleted'] as bool? ?? false,
      selectedTab: json['selectedTab'] as int, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isInitialized': isInitialized,
      'isLoggedIn': isLoggedIn,
      'isOnboardingCompleted': isOnboardingCompleted,
      'selectedTab': selectedTab
    };
  }
}