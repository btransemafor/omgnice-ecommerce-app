// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_item_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/card_item.dart';
import 'package:provider/provider.dart';

// Centralized Theme Class
class AppTheme {
  // Colors
  static const Color primary = Color(0xFF009688); // Teal for buttons
  static const Color accent = Color(0xFF4CAF50); // Green for success
  static const Color background = Color(0xFFF5F5F5); // Grey background
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA000);

  // Typography
  static TextStyle headline = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  static TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );
  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  // Spacing
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;

  // Border Radius
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;

  // Shadows
  static BoxShadow cardShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    spreadRadius: 1,
    blurRadius: 6,
    offset: const Offset(0, 2),
  );

  // Icon Sizes
  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
}

class OrderDetailScreen extends StatefulWidget {
  final OrderEntity order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool is_expand = false;
  @override
  Widget build(BuildContext context) {
    print(widget.order);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: BeautifulAppBar(
          title: 'Order Detail',
          gradient: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 5, right: 5),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  // border: Border.all(color: Colors.grey.shade200,),
                ),
                child: IconButton(
                    onPressed: () {
                      // Todo: Show Return Home ....
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                          contentPadding: const EdgeInsets.all(24),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.home_outlined,
                                  color: Colors.green[700], size: 40),
                              const SizedBox(height: 16),
                              Text(
                                'Do you want to return home ?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          actionsPadding:
                              const EdgeInsets.only(bottom: 16, right: 16),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Provider.of<ScreenManager>(context,
                                        listen: false)
                                    .goToHome();
                                context.goNamed('home');
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green[700],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                'Yes',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: Text(
                                'Close',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20,
                    )),
              ),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(3),
          children: [
            Stack(children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 1, right: 1),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    _buildDeliveryInfo(size),
                    const SizedBox(
                      height: 10,
                    ),
                    build_payment_section(size),
                    AddressInfoCard(address: widget.order.address),
                  ],
                ),
              ),
              OrderStatusBanner(status: widget.order.orderStatus ?? ''),
            ]),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.only(left: 3, right: 3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    OrderItemList(items: widget.order.items ?? []),
                    Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: size.height * 0.02,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              is_expand = !is_expand;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  is_expand ? 'Hide Details' : 'View Details',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4),
                                AnimatedRotation(
                                  turns: is_expand ? 0.5 : 0,
                                  duration: Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    AnimatedContainer(
                      width: double.infinity,
                      duration: Duration(milliseconds: 400),
                      height: is_expand ? 240 : 0,
                      curve: Curves.easeInOut,
                      child: SingleChildScrollView(
                        // Add ScrollView to prevent overflow
                        physics: NeverScrollableScrollPhysics(),
                        child: AnimatedOpacity(
                          opacity: is_expand ? 1 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(top: is_expand ? 8 : 0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRow(
                                  "Subtotal",
                                  FormatCurrency.formatCurrency(
                                      widget.order.orderTotal +
                                          widget.order.discountAmount -
                                          widget.order.shippingFee),
                                ),
                                SizedBox(height: 8),
                                _buildRow(
                                  "Discount",
                                  "-${FormatCurrency.formatCurrency(widget.order.discountAmount)}",
                                  color: Colors.red,
                                ),
                                SizedBox(height: 8),
                                _buildRow(
                                  "Delivery Fee",
                                  FormatCurrency.formatCurrency(
                                      widget.order.shippingFee),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Divider(thickness: 1),
                                ),
                                _buildRow(
                                  "Total",
                                  FormatCurrency.formatCurrency(
                                      widget.order.orderTotal),
                                  isBold: true,
                                  color: Colors.green.shade700,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 20.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Gan Set Order ID
                                      Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .setOrderId(widget.order.id ?? '');
                                      context.pushNamed('trackOrder');
                                    },
                                    icon: const Icon(
                                      Icons.local_shipping,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Track Order',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 63, 62, 71),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.teal.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  // Hành động khi nhấn nút
                  context.pushNamed('contactScreen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400], // Màu xám nhẹ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Bo góc nhẹ
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Dễ nhìn
                  elevation: 3, // Đổ bóng nhẹ
                ),
                child: Text(
                  'Do you need help ?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //margin: EdgeInsets.only(left: 3, right: 3),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: OrderMetaSection(
                paidAt: widget.order.paidAt,
                updateAt: widget.order.updateAt,
                orderStatus: widget.order.orderStatus ?? '',
                orderId: widget.order.id ?? '',
                createdAt: widget.order.orderDate,
                completedAt: widget.order.deliveryCompletedAt,
              ),
            ),
          ],
        ));
  }

  Widget _buildRow(String label, String value,
      {bool isBold = false, Color? color}) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: size.height * 0.015,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: size.height * 0.017,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

// Styled Delivery Info Widget
  Widget _buildDeliveryInfo(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 50, 202, 45).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: Color.fromARGB(255, 19, 79, 4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Delivery Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                //
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.order.shipping ?? 'Undefined',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Spacer(),
                    Text(
                      FormatCurrency.formatCurrency(widget.order.shippingFee),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                // Thời gian vận chuyển
                Row(
                  children: [
                    Text(
                      'Time Delivery',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Spacer(),
                    Text(' ${format(widget.order.deliveryCompletedAt)}')
                  ],
                )
              ],
            ),
          ),
          if (widget.order.deliveryCompletedAt != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Successful',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          format(widget.order.deliveryCompletedAt),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget Button Link Screen Contact

  Widget build_payment_section(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 50, 202, 45).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.wallet_outlined,
                    color: Color.fromARGB(255, 19, 79, 4),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Name payment',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Spacer(),
                      Text(widget.order.paymentMethod)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.order.paidAt != null
                      ? Row(
                          children: [
                            Text(
                              'Time payment',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Spacer(),
                            Text(format(widget.order.paidAt))
                          ],
                        )
                      : SizedBox.shrink()
                ],
              ),
            )
          ]),
    );
  }
}

// Order Status Banner Widget
class OrderStatusBanner extends StatelessWidget {
  final String status;
  const OrderStatusBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final lowerStatus = status.toLowerCase();
    Color bgColor;
    String displayText;

    switch (lowerStatus) {
      case 'delivered':
      case 'completed':
        bgColor = AppTheme.accent;
        displayText = 'Order is completed';
        break;
      case 'processing':
        bgColor = AppTheme.warning;
        displayText = 'Order is processing';
        break;
      case 'cancel':
      case 'canceled':
        bgColor = AppTheme.error;
        displayText = 'Order is canceled';
        break;
      default:
        bgColor = AppTheme.textSecondary;
        displayText = 'Order status: $status';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.mediumPadding),
      margin: const EdgeInsets.only(
          bottom: AppTheme.mediumPadding,
          top: AppTheme.smallPadding,
          left: 15,
          right: 15),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        displayText,
        style: AppTheme.subtitle.copyWith(color: Colors.white),
      ),
    );
  }
}

class OrderItemList extends StatelessWidget {
  final List<OrderItemEntity> items;

  const OrderItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Calculate lại số lượng item trong tổng đơn hàng
    final totalQuantity =
        items.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Items in order",
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: size.height * 0.02),
            ),
            Text(
              "$totalQuantity item${items.length > 1 ? 's' : ''}",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: size.height * 0.02),
            ),
          ],
        ),
        Divider(),
        const SizedBox(height: 12),
        ...items.map((item) => CardItem(item: item))
      ],
    );
  }
}

class OrderSummarySection extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double discount;

  const OrderSummarySection({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + deliveryFee - discount;

    Text _line(String title, String value, {FontWeight? fontWeight}) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: fontWeight ?? FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        _line("Subtotal", "${subtotal.toStringAsFixed(0)}đ"),
        const SizedBox(height: 4),
        _line("Delivery Fee", "${deliveryFee.toStringAsFixed(0)}đ"),
        const SizedBox(height: 4),
        _line("Discount", "-${discount.toStringAsFixed(0)}đ"),
        const SizedBox(height: 8),
        _line("Total", "${total.toStringAsFixed(0)}đ",
            fontWeight: FontWeight.bold),
      ],
    );
  }
}

String format(DateTime? time) {
  if (time == null) return "undefined";
  return DateFormat('dd-MM-yyyy, HH:mm:ss').format(time.toLocal());
}

class OrderMetaSection extends StatelessWidget {
  final String orderId;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final DateTime? updateAt;
  final DateTime? paidAt;
  final String orderStatus;

  const OrderMetaSection(
      {super.key,
      required this.orderId,
      this.createdAt,
      this.completedAt,
      this.updateAt,
      this.paidAt,
      required this.orderStatus});

  String format(DateTime? time) {
    if (time == null) return "undefined";
    return DateFormat('dd-MM-yyyy, HH:mm:ss').format(time.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //const Divider(height: 32),
        Text(
          "Order Details",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.015,
          ),
        ),
        const SizedBox(height: 10),
        _metaRow(context, "Order ID", orderId, showCopy: true),
        _metaRow(context, "Order Time", format(createdAt)),
        paidAt != null
            ? _metaRow(context, "Payment Time", format(paidAt))
            : SizedBox.shrink(),
        completedAt != null
            ? _metaRow(context, "Completed Time", format(completedAt))
            : SizedBox.shrink(),
        orderStatus == 'cancel' && updateAt != null
            ? _metaRow(context, 'Cancelled Time', format(updateAt))
            : SizedBox.shrink()
      ],
    );
  }

  Widget _metaRow(BuildContext context, String title, String value,
      {bool showCopy = false}) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: size.height * 0.013, color: Colors.grey[800]),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(fontSize: size.height * 0.013),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (showCopy)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                    },
                    child: Text(
                      "Copy",
                      style: GoogleFonts.poppins(
                        fontSize: size.height * 0.013,
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressInfoCard extends StatelessWidget {
  final AddressEntity address;
  final bool isCollapsed;
  final VoidCallback? onTap;

  const AddressInfoCard({
    super.key,
    required this.address,
    this.isCollapsed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final details =
        "${address.address.details ?? ''}, ${address.address.ward}, ${address.address.district}, ${address.address.province}";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 215, 111)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color.fromARGB(255, 9, 84, 32),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shipping Address",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.fullName ?? '-',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android_rounded,
                            size: 18,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            address.phone ?? '-',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            size: 18,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isCollapsed && details.length > 40
                                  ? "${details.substring(0, 40)}..."
                                  : details,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isCollapsed && details.length > 40)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: onTap,
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "View more",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
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
