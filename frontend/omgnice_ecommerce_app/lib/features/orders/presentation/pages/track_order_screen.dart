import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/core/widgets/animatedNote.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<OrderProvider>(context, listen: false);
    final String orderCode = provider.orderId ?? '';
    Future.microtask(() async {
      await provider.getOrderByCode(orderCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BeautifulAppBar(title: 'Track Order', gradient: true),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<OrderProvider>(
          builder: (context, provider, _) {
            final order = provider.orderByCode;

            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6A62B7),
                ),
              );
            }

            if (order == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Order not found",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _OrderStatus(status: order.orderStatus ?? 'pending'),
                  const SizedBox(height: 24),
                  _OrderInfo(),
                  const SizedBox(height: 16),
                  _OrderItemsList(),
                  const SizedBox(height: 16),
                  _TrackingTimeline(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Button(
                      oke: true,
                      textButton: 'View Details',
                      handleButton: () {
                        context.goNamed('userOrderDetail', extra: order);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderStatus extends StatelessWidget {
  final String status;

  const _OrderStatus({required this.status});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFF5E60CE);
      case 'processing':
        return const Color.fromARGB(255, 8, 125, 209);
      case 'shipping':
        return const Color.fromARGB(255, 18, 183, 166);
      case 'completed':
        return const Color.fromARGB(255, 16, 207, 58);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(status).withOpacity(0.8),
            _getStatusColor(status).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(status).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(status),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusMessage(status),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.autorenew;
      case 'processing':
        return Icons.local_shipping;
      case 'shipping':
        return Icons.density_large;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Waiting for confirmation.';
      case 'processing':
        return 'Preparing your order.';
      case 'shipping':
        return 'On the way.';
      case 'completed':
        return 'Delivered successfully.';
      case 'cancel':
        return 'Order cancelled.';
      default:
        return 'Status updating...';
    }
  }
}

class _OrderInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().orderByCode!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Order Information',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '#${order.id ?? ''}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: Colors.grey[200]),
            const SizedBox(height: 20),
            _InfoTile(
              icon: Icons.location_on,
              title: 'Delivery Address',
              subtitle:
                  '${order.address.fullName} (${order.address.phone})\n${order.address.address.details}, ${order.address.address.ward}, ${order.address.address.district}, ${order.address.address.province}',
            ),
            const SizedBox(height: 16),
            _InfoTile(
              icon: Icons.local_shipping,
              title: 'Shipping Method',
              subtitle: order.shippingMethodId ?? 'Standard Delivery',
            ),
            const SizedBox(height: 16),
            _InfoTile(
              icon: Icons.payment,
              title: 'Payment Method',
              subtitle: order.paymentMethod ?? 'Cash on Delivery',
            ),
            if (order.orderDate != null) ...[
              const SizedBox(height: 16),
              _InfoTile(
                icon: Icons.calendar_today,
                title: 'Order Date',
                subtitle: DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate!.toLocal()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Icon(
            icon,
            color: Colors.grey[700],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = context.watch<OrderProvider>().orderByCode?.items ?? [];

    if (items.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text("No items found"),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Order Items',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.thumbnail ?? '',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName ?? 'Product',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Size: ${item.variantName ?? 'Standard'}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 46, 196, 89),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${NumberFormat("#,###").format(item.price.toInt())} VND',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Qty: ${item.quantity}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AnimatedNoteContainer(item: item)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TrackingTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().orderByCode;
    final status = order?.orderStatus?.toLowerCase() ?? '';
    bool orderPlaced = true;
    bool preparing = ['processing', 'shipping', 'completed'].contains(status);
    bool shipping = ['shipping', 'completed'].contains(status);
    bool delivered = status == 'completed';
    bool cancelled = status == 'cancel';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Timeline',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _TimelineStep(
            title: 'Order Placed',
            description: 'Your order has been received',
            isActive: orderPlaced,
            //isFirst: true,
            date: order?.orderDate != null
                ? DateFormat('dd/MM/yyyy HH:mm')
                    .format(order!.orderDate!.toLocal())
                : null,
          ),
          _TimelineStep(
            title: 'Processing',
            description: 'Preparing your order',
            isActive: preparing,
            date: preparing ? 'In progress' : null,
          ),
          _TimelineStep(
            title: 'Shipping',
            description: 'Your order is on the way',
            isActive: shipping,
            date:  order?.deliveryCompletedAt != null
                ? custom_format(order!.deliveryCompletedAt!)
                : delivered
                    ? 'On the way'
                    : null,
          ),
          _TimelineStep(
            title: 'Completed',
            description: 'Your order has been completed',
            isActive: delivered,
            isLast: delivered,
            date: order?.deliveryCompletedAt != null
                ? custom_format(order!.deliveryCompletedAt!)
                : delivered
                    ? 'Completed'
                    : null,
          ),
          if (cancelled)
            _TimelineStep(
              title: 'Cancel',
              description: 'Your order has been cancelled',
              isActive: cancelled,
              isCancel: true,
              isLast: true,
              date: order?.updateAt != null
                  ? DateFormat('dd/MM/yyyy').format(order!.updateAt!)
                  : 'Cancelled',
            ),
        ],
      ),
    );
  }
}



class _TimelineStep extends StatelessWidget {
  final bool isActive;
  final bool isCancel;
  bool isLast;
  final String title;
  final String description;
  final String? date;

  _TimelineStep({
    Key? key,
    required this.isActive,
    this.isCancel = false,
    this.isLast = false,
    required this.title,
    required this.description,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.green[600]
                    : isCancel
                        ? Colors.red[600]
                        : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive
                      ? Colors.green[700]!
                      : isCancel
                          ? Colors.red[700]!
                          : Colors.grey[300]!,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isActive
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 70,
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [
                            Colors.green[600]!,
                            Colors.green[400]!,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: isActive ? null : Colors.grey[300],
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 28, top: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: isLast
                    ? BorderSide.none
                    : BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive
                              ? Colors.black87
                              : isCancel
                                  ? Colors.red[600]
                                  : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (date != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      date!,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: isActive
                            ? Colors.green[600]
                            : isCancel
                                ? Colors.red[600]
                                : Colors.grey[600],
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


  String custom_format(DateTime? time) {
    if (time == null) return "---";
    return DateFormat('dd/MM/yyyy, HH:mm').format(time.toLocal());
  }