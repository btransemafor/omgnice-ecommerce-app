import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/features/admin/orders/presentation/widgets/admin_order_card.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';

class OrderProcessScreenAd extends StatefulWidget {
  const OrderProcessScreenAd({super.key});

  @override
  State<OrderProcessScreenAd> createState() => _OrderProcessScreenAdState();
}

class _OrderProcessScreenAdState extends State<OrderProcessScreenAd> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderProvider>().fetchAllOrder());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallScreen = screenWidth < 600;
    final isLargeScreen = screenWidth > 900;
    final padding = isSmallScreen
        ? 12.0
        : isLargeScreen
            ? 24.0
            : 16.0;
    final fontSizeBase = isSmallScreen
        ? 14.0
        : isLargeScreen
            ? 18.0
            : 16.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, fontSizeBase),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
     /*      if (provider.isLoading ) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.green));
          } */

          final processingStatuses = ['pending', 'processing', 'shipping'];
          final orders = provider.getOrdersByStatus(processingStatuses);

          return _buildBody(context, orders, padding, fontSizeBase);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, double fontSizeBase) {
    return AppBar(
      title: Text(
        'Processing Orders',
        style: GoogleFonts.poppins(
          fontSize: fontSizeBase + 2,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: Colors.white, size: fontSizeBase + 4),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.green[700],
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[700]!, Colors.green[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<OrderEntity> orders,
      double padding, double fontSizeBase) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderListHeader(orders, padding, fontSizeBase),
          orders.isEmpty
              ? _buildEmptyState(padding, fontSizeBase)
              : _buildOrderList(orders, padding),
          SizedBox(height: padding),
        ],
      ),
    );
  }

  Widget _buildOrderListHeader(
      List<OrderEntity> orders, double padding, double fontSizeBase) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Orders',
            style: GoogleFonts.poppins(
              fontSize: fontSizeBase + 2,
              fontWeight: FontWeight.w700,
              color: Colors.green[800],
            ),
          ),
          Text(
            '${orders.length} found',
            style: GoogleFonts.poppins(
                fontSize: fontSizeBase, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double padding, double fontSizeBase) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Center(
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
            SizedBox(height: padding),
            Text(
              'No orders being processed',
              style: GoogleFonts.poppins(
                fontSize: fontSizeBase,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: padding * 0.5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding * 2),
              child: Text(
                'Orders being processed will appear here',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: fontSizeBase - 2, color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderEntity> orders, double padding) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding:
          EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.3),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return AdminOrderCard(key: ValueKey(order.id), order: order);
      },
    );
  }
}
