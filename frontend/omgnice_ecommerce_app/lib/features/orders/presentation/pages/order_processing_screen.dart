import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/order_card.dart';
import 'package:provider/provider.dart';

class OrderProcessingScreen extends StatelessWidget {
  const OrderProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final processingStatuses = ['pending', 'processing', 'shipping'];
    final orderProcessing = provider.getOrdersByStatus(processingStatuses);

    // Display a polished empty state if there are no processing orders
    if (orderProcessing.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_order.png',
              height: 150,
              width: 150,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.receipt_long,
                size: 100,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No orders being processed',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Orders being processed will appear here',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                context.goNamed('home');
                Provider.of<ScreenManager>(context, listen: false).goToHome();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Continue Shopping',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Sort orders by date (newest first) and group by status for better organization
    orderProcessing.sort((a, b) => b.orderDate!.compareTo(a.orderDate!));

    // Display the list of processing orders with refresh
    return RefreshIndicator(
      color: Colors.green,
      onRefresh: () async {
        await context.read<OrderProvider>().getOrders();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: orderProcessing.length,
        itemBuilder: (context, index) {
          final item = orderProcessing[index];
          return GestureDetector(
            child: OrderCard(order: item),
            onTap: () {
              context.pushNamed('userOrderDetail', extra: item);
            },
          );
        },
      ),
    );
  }
}
