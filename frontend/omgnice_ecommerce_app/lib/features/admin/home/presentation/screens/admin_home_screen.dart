// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/admin/customers/presentation/screens/user_list_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/home/presentation/screens/admin_dashboard_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/orders/presentation/screens/admin_order_list_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/screens/ad_product_list_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/setting/presentation/screens/admin_setting_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/widgets/admin_bottom_navigator.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});
  static final _pageAdmins = [
    AdminDashboardScreen(),
    //DrinkSalesStatsPage(),
    AdminOrderListScreen(),
    UserListScreen(),
    // MonthlyOrderChart()
    //MoMoPaymentScreen()
    //DrinkSalesStatsPage(),
    ProductListScreen(),
   // MonthlyOrderChart(),
    AdminSettingScreen()
    
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenManager>(
      builder: (context, screenManager, _) {
        return Scaffold(
          body: _pageAdmins[screenManager.currentIndex],
          bottomNavigationBar: AdminBottomNavigation(
              currentIndex: screenManager.currentIndex,
              onSelectedItem: (index) => screenManager.changeScreen(index)),
        );
      },
    );
  }
}
