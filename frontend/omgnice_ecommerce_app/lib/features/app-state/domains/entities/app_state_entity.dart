class AppStateEntity {
  final bool isInitialized;
  final bool isLoggedIn;
  final bool isOnboardingCompleted;
  final int selectedTab; 
  const AppStateEntity({
    this.isInitialized = false,
    this.isLoggedIn = false,
    this.isOnboardingCompleted = false,
    this.selectedTab = 1 
  });

}