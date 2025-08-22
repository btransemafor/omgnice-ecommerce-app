import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/entities/app_state_entity.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/usecase/get_app_state.dart';
import 'package:omgnice_ecommerce_app/features/app-state/domains/usecase/save_app_state.dart';

class AppStateManager extends ChangeNotifier {
   final GetAppState getAppStateUseCase;
   final SaveAppState saveAppStateUseCase;
    AppStateManager({
      required this.getAppStateUseCase,
      required this.saveAppStateUseCase, 
}); 

  
    bool _isInitialized = false;
    bool _isLoggedIn = false;
    bool _isOnboardingCompleted = false;
    int _selectedTab = 0; 
  
    bool get isInitialized => _isInitialized;
    bool get isLoggedIn => _isLoggedIn;
    bool get isOnboardingCompleted => _isOnboardingCompleted;
    int get selectedTab => _selectedTab; 
  
    Future<void> loadAppState() async {
      final appState = await getAppStateUseCase.call();
      _isInitialized = appState.isInitialized;
      _isLoggedIn = appState.isLoggedIn;
      _isOnboardingCompleted = appState.isOnboardingCompleted;
      _selectedTab = appState.selectedTab; 
      notifyListeners();
    }



// Initialize app state
  void initializeAppState() async {
    // Thuc hien logic khoi tao trang thai tai day
    // Get app state tu sharedPreferences
    final appState = await getAppStateUseCase.call();
    _isLoggedIn = appState.isLoggedIn;
    _isOnboardingCompleted = appState.isOnboardingCompleted;
    _selectedTab = 0;
    

    // Delay de cho khoi tao 2s 
    await Future.delayed(const Duration(seconds: 2));
    // Neu khoi tao thanh cong, cap nhat trang thai
    _isInitialized = true;
    _saveCurrentState();
    notifyListeners();
  }
  // Login 
  void login(String email, String password) async {
    // Thuc hien logic dang nhap tai day
    // Neu dang nhap thanh cong, cap nhat trang thai
    _isLoggedIn = true;
    _saveCurrentState();
    notifyListeners();
  }

  // Logout 
  Future <void> logout() async {
    // Thuc hien logic dang xuat tai day
    // Neu dang xuat thanh cong, cap nhat trang thai
    _isLoggedIn = false;
    _isInitialized = false;
    _selectedTab = 0 ; 
    _saveCurrentState(); 
    notifyListeners();

  }


  Future<void> _saveCurrentState() async{
    // Khai bao State 
    final appState = AppStateEntity(
      isInitialized: _isInitialized,
      isLoggedIn: _isLoggedIn,
      isOnboardingCompleted: _isOnboardingCompleted,
      selectedTab: _selectedTab
    );

    // Luu State vao sharedPrefrenced
    await saveAppStateUseCase.setAppState(appState);
    notifyListeners();
  }
}