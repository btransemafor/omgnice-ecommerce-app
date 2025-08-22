import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_item_entity.dart';
import 'package:omgnice_ecommerce_app/features/reviews/presentation/screens/review_screen.dart';

class SelectReviewItemScreen extends StatelessWidget {
  final OrderEntity order;

  const SelectReviewItemScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order.items ?? [];

    // Debug print with safety check
    if (items.isNotEmpty && items[0].order_line_id != null) {
      print('First item order_line_id: ${items[0].order_line_id}');
    } else {
      print('No items or order_line_id is null');
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BeautifulAppBar(
        title: "Choose Product",
        gradient: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${items.length} items',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 255, 252, 252),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Order #${order.id}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'No items available for review',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      print('Item ${index + 1}: order_line_id = ${item.order_line_id}');
                      return ReviewItemCard(
                        item: item,
                        onTap: !(item.is_review ?? false)
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReviewScreen(
                                      item: item,
                                      orderId: order.id ?? '',
                                    ),
                                  ),
                                );
                              }
                            : () {
                                _showDialog(context);
                              },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Notice',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          'You have already reviewed this product.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

class ReviewItemCard extends StatelessWidget {
  final OrderItemEntity item;
  final VoidCallback? onTap;

  const ReviewItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.network(
                      item.thumbnail ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 28,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName ?? 'Unknown Product',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.variantName != null && item.variantName!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.green[200]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            item.variantName ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Quantity: ${item.quantity ?? 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.is_review ?? false ? 'Reviewed' : 'Review now',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}