import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class AdminOrderCard extends StatefulWidget {
  final OrderEntity order;

  const AdminOrderCard({super.key, required this.order});

  @override
  State<AdminOrderCard> createState() => _AdminOrderCardState();
}

class _AdminOrderCardState extends State<AdminOrderCard>
    with TickerProviderStateMixin {
  late String currentStatus;
  late AnimationController _animationController;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.order.orderStatus ?? 'pending';
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AdminOrderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.orderStatus != widget.order.orderStatus) {
      setState(() {
        currentStatus = widget.order.orderStatus ?? 'pending';
      });
    }
  }

  Future<void> _updateStatus() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    String? nextStatus;
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        nextStatus = 'processing';
        break;
      case 'processing':
        nextStatus = 'shipping';
        break;
      case 'shipping':
        nextStatus = 'completed';
        break;
      default:
        nextStatus = null;
    }

    if (nextStatus != null) {
      try {
        Map<String, String> updateData = {};
        if (nextStatus == 'completed') {
          updateData = {
            'paymentStatus': 'true',
            'paidAt': DateTime.now().toIso8601String(),
            'orderStatus': nextStatus,
            'deliveryCompletedAt': DateTime.now().toIso8601String(),
          };
        } else {
          updateData = {'orderStatus': nextStatus};
        }

        await orderProvider.updateOrder(widget.order.id ?? '', updateData);
        setState(() {
          currentStatus = nextStatus!;
        });
        orderProvider.fetchAllOrder();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update status: $e'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
        debugPrint('Error updating status: $e');
      }
    } else {
      debugPrint('No valid next status for: $currentStatus');
    }
  }

  String _getActionButtonLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Approve Order';
      case 'processing':
        return 'Mark as Shipping';
      case 'shipping':
        return 'Mark as Delivered';
      default:
        return '';
    }
  }

  Color getColorStatusForOrder(String? status) {
    debugPrint('getColorStatusForOrder called with status: $status');
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade400;
      case 'processing':
        return Colors.blue.shade400;
      case 'shipping':
        return Colors.indigo.shade400;
      case 'completed':
        return Colors.green.shade400;
      case 'cancelled':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '---';
    return DateFormat('dd/MM/yyyy, HH:mm:ss').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 12.0 : 18.0;
    final fontSizeBase = isSmallScreen ? 13.0 : 14.0;
    final buttonFontSize = fontSizeBase * 0.9;

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _opacityAnimation, _hoverAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _hoverAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _isHovered = true);
                _hoverController.forward();
              },
              onExit: (_) {
                setState(() => _isHovered = false);
                _hoverController.reverse();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: padding * 0.7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered 
                          ? Colors.black.withOpacity(0.15)
                          : Colors.black.withOpacity(0.08),
                      blurRadius: _isHovered ? 20 : 12,
                      offset: _isHovered ? const Offset(0, 8) : const Offset(0, 4),
                      spreadRadius: _isHovered ? 2 : 0,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.9),
                      blurRadius: 1,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey.shade50.withOpacity(0.8),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    border: Border.all(
                      color: Colors.grey.shade200.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1: Order ID + Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '#${widget.order.id ?? 'N/A'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: fontSizeBase + 1,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _formatDate(widget.order.orderDate),
                                  style: GoogleFonts.poppins(
                                    fontSize: fontSizeBase - 1,
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: padding * 0.8),
                          
                          // Status Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: getColorStatusForOrder(currentStatus),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: getColorStatusForOrder(currentStatus)
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              currentStatus.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: fontSizeBase * 0.85,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: padding),
                          
                          // Customer Info Card
                          Container(
                            padding: EdgeInsets.all(padding * 0.8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Customer Name + Phone
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.person_outline,
                                        size: fontSizeBase + 2,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                    SizedBox(width: padding * 0.7),
                                    Expanded(
                                      child: Text(
                                        widget.order.address.fullName ?? 'N/A',
                                        style: GoogleFonts.poppins(
                                          fontSize: fontSizeBase,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.phone_outlined,
                                        size: fontSizeBase,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                    SizedBox(width: padding * 0.4),
                                    Text(
                                      widget.order.address.phone ?? 'N/A',
                                      style: GoogleFonts.poppins(
                                        fontSize: fontSizeBase - 1,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: padding * 0.7),
                                
                                // Address
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        size: fontSizeBase + 2,
                                        color: Colors.orange.shade600,
                                      ),
                                    ),
                                    SizedBox(width: padding * 0.7),
                                    Expanded(
                                      child: Text(
                                        '${widget.order.address.address.district ?? 'N/A'} - ${widget.order.address.address.province ?? 'N/A'} - ${widget.order.address.address.ward ?? 'N/A'}',
                                        style: GoogleFonts.poppins(
                                          fontSize: fontSizeBase - 1,
                                          color: Colors.grey.shade700,
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: padding),
                          
                          // Total + Payment Method
                          Container(
                            padding: EdgeInsets.all(padding * 0.8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade50,
                                  Colors.green.shade100.withOpacity(0.5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.green.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.wallet_membership_outlined,
                                  color: Colors.green.shade600,
                                  size: fontSizeBase + 4,
                                ),
                                const SizedBox(width: 5,),
                                Text(
                                  FormatCurrency.formatCurrency(widget.order.orderTotal),
                                  style: GoogleFonts.poppins(
                                    fontSize: fontSizeBase + 3,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    widget.order.paymentMethod ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                      fontSize: fontSizeBase - 1,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: padding * 1.2),
                          
                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildActionButton(
                                context,
                                label: 'View Details',
                                color: Colors.grey.shade600,
                                onPressed: () {
                                  context.pushNamed('orderDetailScreen',
                                      extra: widget.order);
                                },
                                fontSize: buttonFontSize,
                                padding: padding,
                                isOutlined: true,
                              ),
                              if (currentStatus != 'completed' &&
                                  currentStatus != 'cancelled') ...[
                                SizedBox(width: padding * 0.7),
                                _buildActionButton(
                                  context,
                                  label: _getActionButtonLabel(currentStatus),
                                  color: getColorStatusForOrder(currentStatus),
                                  onPressed: _updateStatus,
                                  fontSize: buttonFontSize,
                                  padding: padding,
                                  isOutlined: false,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required double fontSize,
    required double padding,
    required bool isOutlined,
  }) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 150),
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color, width: 1.5),
                padding: EdgeInsets.symmetric(
                  horizontal: padding * 1.2,
                  vertical: padding * 0.8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(
                  horizontal: padding * 1.2,
                  vertical: padding * 0.8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: color.withOpacity(0.4),
              ),
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}