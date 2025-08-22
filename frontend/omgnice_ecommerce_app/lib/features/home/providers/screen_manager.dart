import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../products/presentation/providers/category_provider.dart';

class ScreenManager extends ChangeNotifier {
  // 5 tab
  int _currentIndex = 0;

  // Getter
  int get currentIndex => _currentIndex;
  /*
  void onItemSelected(index) {
    _currentIndex = index;
    notifyListeners();
  }

   */
  void onItemSelected(int index, BuildContext context) {
    _currentIndex = index;

    //  Nếu quay lại HomePage (index = 0), thì reset CategoryProvider về 0
    if (_currentIndex == 0) {
      Provider.of<CategoryProvider>(context, listen: false).selectCategory(0);
      print("Reset CategoryProvider về 0");
    }

    notifyListeners();
  }

  void switchToCartScreen() {
    _currentIndex = 2;
    notifyListeners();
  }

  void tapBackButton() {
    _currentIndex = 0;
    notifyListeners();
  }

  void goToHome() {
    _currentIndex = 0;
    notifyListeners();
  }

  void changeScreen(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
