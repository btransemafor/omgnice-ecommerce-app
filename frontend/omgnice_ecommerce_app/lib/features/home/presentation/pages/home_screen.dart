
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/screens/test_fav.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/pages/custom_home_page.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/user_center_screen.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/pages/promotion_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static final List<Widget> _pages = [
    CustomHomePage(),
    TestFav(), 
    //Container(color: Colors.white),
    CartScreen(), //  Màn hình Cart ở index = 2
    PromotionScreen(), 
    UserCenterScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenManager>(
      builder: (context, screenManager, _) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: _pages[screenManager.currentIndex],

          floatingActionButton: screenManager.currentIndex == 2 // Ẩn FAB nếu đang ở CartScreen
              ? null
              : FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 10,
            shape: const CircleBorder(),
            onPressed: screenManager.switchToCartScreen,
            child: const Icon(Icons.shopping_cart, color: Colors.green),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          // Ẩn BottomNavigationBar nếu đang ở CartScreen
          bottomNavigationBar: screenManager.currentIndex == 2
              ? null
              : CustomBottomNavigationBar(
            currentIndex: screenManager.currentIndex,
            fabIcon: Icons.shopping_cart,
            fabIndex: 2,
            onItemSelected: (index) => screenManager.onItemSelected(index, context), // Truyền context vào đây
          ),
        );
      },
    );
  }
}
