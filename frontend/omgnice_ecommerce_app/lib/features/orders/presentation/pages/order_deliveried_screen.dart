import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/order_card.dart';
import 'package:provider/provider.dart';

class OrderDeliveriedScreen extends StatelessWidget {
  const OrderDeliveriedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();

    final orders = provider.order;
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          'No orders',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ]));
    }

    final deliveredOrders = provider.getOrdersByStatus('completed');
  //  print('Delivered Orders: ${deliveredOrders[0].items?[0].order_line_id}');

    if (deliveredOrders.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          'No orders',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ]));
    }

    return RefreshIndicator(
      color: Colors.green,
      onRefresh: () async {
        await context.read<OrderProvider>().getOrders();
      },
      child: ListView.builder(
        physics:
            const AlwaysScrollableScrollPhysics(), // Đảm bảo luôn cuộn được
        itemCount: deliveredOrders.length,
        itemBuilder: (context, index) {
          final order = deliveredOrders[index];
          print(
              "🧾 order = ${order.id}, status = ${order.orderStatus}, total = ${order.orderTotal}");
              print("🧾 order items = ${order.items?.map((item) => item.order_line_id)}");
          return GestureDetector(
            onTap: () {
              context.pushNamed('userOrderDetail', extra: order);
            },
            child: OrderCard(order: order),
          );
        },
      ),
    );
  }
}
