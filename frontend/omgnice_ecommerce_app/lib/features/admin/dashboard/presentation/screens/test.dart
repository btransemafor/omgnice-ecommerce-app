import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:provider/provider.dart';

// Model for order data
class OrderByMonth {
  final String month; // Format: YYYY-MM
  final int orderCount;

  OrderByMonth({
    required this.month,
    required this.orderCount,
  });
}

class MonthlyOrderChart extends StatelessWidget {
  // Mock data for the last 6 months
  final List<OrderByMonth> orderData = [
    OrderByMonth(month: '2025-01', orderCount: 120),
    OrderByMonth(month: '2025-02', orderCount: 150),
    OrderByMonth(month: '2025-03', orderCount: 100),
    OrderByMonth(month: '2025-04', orderCount: 180),
    OrderByMonth(month: '2025-05', orderCount: 200),
    OrderByMonth(month: '2025-06', orderCount: 170),
    OrderByMonth(month: '2025-07', orderCount: 180),
    OrderByMonth(month: '2025-08', orderCount: 200),
    OrderByMonth(month: '2025-09', orderCount: 1000),
  ];

   MonthlyOrderChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
           const SizedBox(height: 20),
                              SizedBox(
                              
                                height: 50,
                                child: Button(
                                    oke: false,
                                    textButton: 'Sign Out',
                                    // Handle sign out action
                                    handleButton: () async {
                                      try {
                                        //  Gọi logout và chờ hoàn tất
                                        await Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .logout();

                                        // Reset về tab 0 trướ khi về trang login
                                        Provider.of<ScreenManager>(context,
                                                listen: false)
                                            .goToHome();

                                        (context).goNamed('login');
                                      } catch (e) {
                                        print("Logout error: $e");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Đăng xuất thất bại. Vui lòng thử lại.')),
                                        );
                                      }
                                    }),
                              ),
        ],
      ),
    );
  }
}