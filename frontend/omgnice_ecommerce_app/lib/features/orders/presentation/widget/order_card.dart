import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_item_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:omgnice_ecommerce_app/features/reviews/presentation/screens/review_select_item_screen.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});
  void handleReturn(OrderEntity order, BuildContext context) {
    // Guard clauses for early returns
    if (order.orderDate == null) {
      _showFloatingMessage(context, 'Unable to process - missing order date');
      debugPrint('⚠️ Order cancellation failed: orderDate is null');
      return;
    }

    // Calculate time difference with elegant naming
    final elapsedTime = DateTime.now().difference(order.orderDate!);

    // Determine cancellation eligibility with clear conditions
    final bool isEligibleForCancellation = _canCancelOrder(order, elapsedTime);

    // Execute appropriate action based on eligibility
    isEligibleForCancellation
        ? _showCancellationConfirmDialog(context, order)
        : _showIneligibleMessage(context);
  }

// Helper methods for cleaner organization

  bool _canCancelOrder(OrderEntity order, Duration elapsedTime) {
    // Orders can be canceled if:
    // 1. Still pending and was placed over an hour ago
    // 2. Any order within first 10 minutes
    return (order.orderStatus == 'pending' && elapsedTime.inMinutes >= 30) ||
        elapsedTime.inMinutes <= 10;
  }

  void _showCancellationConfirmDialog(BuildContext context, OrderEntity order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // More rounded corners
        ),
        title: const Text(
          'Request to Cancel Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel this order?',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 15,
          ),
        ),
        actions: [
          _buildDialogButton(
            context: context,
            label: 'Cancel Order',
            isPrimary: true,
            onPressed: () {
              Navigator.of(context).pop();
              _processCancellation(context, order);
            
            },
          ),
          _buildDialogButton(
            context: context,
            label: 'Keep Order',
            isPrimary: false,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton(
      {required BuildContext context,
      required String label,
      required bool isPrimary,
      required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            isPrimary ? Theme.of(context).primaryColor : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.white : Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

 void _processCancellation(BuildContext context, OrderEntity order) {
  debugPrint("Processing order cancellation for ID: ${order.id}");

  if (order.id?.isEmpty ?? true) {
    _showFloatingMessage(context, 'Unable to process - invalid order ID');
    return;
  }

  Provider.of<OrderProvider>(context, listen: false)
      .updateOrder(order.id!, {"orderStatus": "cancel"})
      .then((_) async {
    // Close loading dialog
    Navigator.of(context).pop();
    
    // Fetch fresh data from server instead of local update
    await Provider.of<OrderProvider>(context, listen: false).fetchAllOrder();
    
    _showFloatingMessage(context, 'Order canceled successfully');
  }).catchError((error) {
    // Close loading dialog
    Navigator.of(context).pop();
    
    debugPrint("Order cancellation error: $error");
    _showFloatingMessage(
        context, 'Failed to cancel order. Please try again.');
  });
}

  void _showIneligibleMessage(BuildContext context) {
    _showFloatingMessage(
        context, 'This order is not eligible for cancellation at this time.');
  }

  void _showFloatingMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final items = order.items ?? [];
    final address = order.address;
    final totalQuantity =
        items.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));
    final orderDateTime = order.orderDate?.toLocal();
    final orderDateStr = orderDateTime != null
        ? "${orderDateTime.day.toString().padLeft(2, '0')}-"
            "${orderDateTime.month.toString().padLeft(2, '0')}-"
            "${orderDateTime.year} "
            "${orderDateTime.hour.toString().padLeft(2, '0')}:"
            "${orderDateTime.minute.toString().padLeft(2, '0')}"
        : "N/A";
    final deliveryDateTime = order.deliveryCompletedAt?.toLocal();

    final deliveryDateStr = deliveryDateTime != null
        ? "${deliveryDateTime.day.toString().padLeft(2, '0')}-"
            "${deliveryDateTime.month.toString().padLeft(2, '0')}-"
            "${deliveryDateTime.year} "
            "${deliveryDateTime.hour.toString().padLeft(2, '0')}:"
            "${deliveryDateTime.minute.toString().padLeft(2, '0')}"
        : "N /A";

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Header: Order ID + Date ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: size.height * 0.017,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    order.deliveryCompletedAt != null
                        ?
                        // Các đon vừa đặt hàng chứ chưa giao.
                        Text(
                            "Deliveried: $deliveryDateStr",
                            style: GoogleFonts.poppins(
                                fontSize: size.height * 0.013),
                          )
                        : Text(
                            "Ordered: $orderDateStr",
                            style: GoogleFonts.poppins(
                                fontSize: size.height * 0.013),
                          )
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 181, 244, 183)
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    order.id ?? '--- ',
                    style: GoogleFonts.poppins(
                        fontSize: size.height * 0.012,
                        color: const Color.fromARGB(255, 12, 121, 36)),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            /// --- List sản phẩm ---
            ...items.map((item) => _buildItemTile(item, size)).toList(),

            const Divider(height: 24),

            /// --- Tổng đơn hàng ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '$totalQuantity item',
                        style: GoogleFonts.poppins(
                            fontSize: size.height * 0.019,
                            color: Colors.green,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "|",
                        style: GoogleFonts.poppins(
                          fontSize: size.height * 0.019,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        FormatCurrency.formatCurrency(order.orderTotal),
                        style: GoogleFonts.poppins(
                            fontSize: size.height * 0.019,
                            color: Colors.green,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                /// Button Review
                ///

                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                     _buildOrderActionButton(order, context, size), 
                      const SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.green,
                        size: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _buildOrderActionButton(OrderEntity order, BuildContext context, Size size) {
  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    side: BorderSide(
      color: order.deliveryCompletedAt != null
          ? Colors.green
          : const Color.fromARGB(255, 219, 75, 22),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    elevation: 0,
  );

  if (order.deliveryCompletedAt != null) {
    return SizedBox(
      height: size.height * 0.03,
      child: ElevatedButton(
        onPressed: () {
          print('order.map: ${order.items?.map((e) => e.order_line_id)}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectReviewItemScreen(order: order),
            ),
          );
        },
        style: buttonStyle,
        child: Text(
          'Review',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  if (order.orderStatus == 'Cancel') {
    return SizedBox(
      height: size.height * 0.03,
      child: ElevatedButton(
        onPressed: () {
          _showFloatingMessage(context, 'This order has been canceled');
        },
        style: buttonStyle,
        child: Text(
          'Canceled',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 219, 79, 19),
          ),
        ),
      ),
    );
  }

  return SizedBox(
    height: size.height * 0.03,
    child: ElevatedButton(
      onPressed: () {
        handleReturn(order, context);
      },
      style: buttonStyle,
      child: Text(
        'Cancel',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color.fromARGB(255, 219, 79, 19),
        ),
      ),
    ),
  );
}

  Widget _buildItemTile(OrderItemEntity item, Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          /// --- Hình ảnh sản phẩm ---
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.thumbnail ?? '',
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 55,
                height: 55,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// --- Tên + size + số lượng ---
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName ?? 'Name Product',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: size.height * 0.016)),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Size: ${item.variantName ?? '-'}",
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 5,
                        ),

                        // Quantity
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'x${item.quantity}',
                            style: GoogleFonts.poppins(
                                color: Colors.pink[500],
                                fontSize: size.height * 0.012),
                          ),
                        ),
                      ],
                    ),

                    /// --- Giá ---
                    Text(
                      FormatCurrency.formatCurrency(item.price),
                      style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: size.height * 0.014),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
