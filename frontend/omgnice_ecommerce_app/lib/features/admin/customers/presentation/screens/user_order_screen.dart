import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/admin/orders/presentation/widgets/admin_order_card.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserOrdersScreen extends StatefulWidget {
  final List<OrderEntity> allOrders;

  const UserOrdersScreen({super.key, required this.allOrders});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

   UserEntity? user ; 


   @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<UserProvider>(context, listen: false).user; 
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    // Simulate refreshing data (replace with actual data fetch logic if needed)
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const accentColor = Colors.green; // Teal accent color
   

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "${ Provider.of<UserProvider>(context, listen: false).user?.name ?? ''}'s orders",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
          /*   gradient: LinearGradient(
              colors: [Colors.teal[800]!, Colors.teal[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ), */
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white, size: 24),
            onPressed: () {
              // Add sort functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sorting functionality coming soon',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  backgroundColor: accentColor,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Sort Orders',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: widget.allOrders.isEmpty
            ? _buildEmptyState(colorScheme, accentColor)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.allOrders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AdminOrderCard(order: widget.allOrders[index]),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, Color accentColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 60,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'No orders found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This user has no order history.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
