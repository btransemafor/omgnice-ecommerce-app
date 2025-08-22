import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';

class AdminOrderDetailScreen extends StatelessWidget {
  final OrderEntity order;
  const AdminOrderDetailScreen({super.key, required this.order});

  void _sendSms(BuildContext context, String phoneNumber) async {
    final message =
        Uri.encodeComponent("Hello, please confirm the details of this order.");
    final uri = Uri.parse('sms:$phoneNumber?body=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open SMS app.',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _callPhone(BuildContext context, String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to make a call.',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'undefined';

    // Chuyển sang giờ Việt Nam (GMT+7)
    final vietnamTime = date.toUtc().add(Duration(hours: 7));
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(vietnamTime);
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAnimatedCard({
    required Widget child,
    required int delay,
    required double radius,
    required double padding,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeInOut,
      child: AnimatedSlide(
        offset: Offset(0, 0),
        duration: Duration(milliseconds: 500 + delay),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, double fontSize) {
    return Row(
      children: [
        Icon(icon, size: fontSize + 2, color: Colors.green[800]),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.green[800],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    required IconData icon,
    required double fontSize,
    required double labelWidth,
    bool isBold = false,
    bool highlight = false,
    Color? statusColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: fontSize * 0.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: fontSize + 2, color: Colors.grey[600]),
          SizedBox(width: fontSize * 0.8),
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 3,
            child: statusColor != null
                ? Chip(
                    label: Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: fontSize * 0.9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: statusColor,
                    padding: EdgeInsets.symmetric(horizontal: fontSize * 0.6),
                  )
                : Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                      color: highlight ? Colors.green[700] : Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required double width,
    required double padding,
    required double fontSize,
  }) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: width,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: fontSize + 4, color: Colors.white),
          label: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(
                horizontal: padding, vertical: padding * 0.8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.3),
            textStyle: GoogleFonts.poppins(),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemsList({
    required double sectionTitleSize,
    required double spacing,
    required double fontSizeBase,
    required double cardRadius,
    required double padding,
  }) {
    if (order.items == null || order.items!.isEmpty) {
      return _buildAnimatedCard(
        delay: 400,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            'No items in this order',
            style: GoogleFonts.poppins(
              fontSize: fontSizeBase,
              color: Colors.grey[600],
            ),
          ),
        ),
        radius: cardRadius,
        padding: padding,
      );
    }

    return _buildAnimatedCard(
      delay: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              'Order Items', Icons.shopping_basket, sectionTitleSize),
          SizedBox(height: spacing * 0.6),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items!.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final item = order.items![index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                            image: item.thumbnail != null
                                ? DecorationImage(
                                    image: NetworkImage(item.thumbnail!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: item.thumbnail == null
                              ? Icon(Icons.image_not_supported,
                                  color: Colors.grey[500])
                              : null,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName ?? 'Unknown Product',
                                style: GoogleFonts.poppins(
                                  fontSize: fontSizeBase,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.variantName != null)
                                Text(
                                  item.variantName!,
                                  style: GoogleFonts.poppins(
                                    fontSize: fontSizeBase - 2,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity: ${item.quantity ?? 0}',
                          style: GoogleFonts.poppins(
                            fontSize: fontSizeBase - 1,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          FormatCurrency.formatCurrency(
                              item.price * (item.quantity ?? 0)),
                          style: GoogleFonts.poppins(
                            fontSize: fontSizeBase,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 7, 146, 61),
                          ),
                        ),
                      ],
                    ),
                    if (item.note != null && item.note!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.note_alt_outlined,
                                size: fontSizeBase,
                                color: Colors.grey[700],
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.note!,
                                  style: GoogleFonts.poppins(
                                    fontSize: fontSizeBase - 1,
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      radius: cardRadius,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final isLargeScreen = screenWidth > 900;

    final padding = isSmallScreen
        ? 12.0
        : isLargeScreen
            ? 24.0
            : 20.0;
    final fontSizeBase = isSmallScreen
        ? 13.0
        : isLargeScreen
            ? 17.0
            : 14.0;
    final sectionTitleSize = fontSizeBase + 4;
    final buttonPadding = isSmallScreen ? 12.0 : 16.0;
    final cardRadius = isSmallScreen ? 12.0 : 16.0;
    final spacing = isSmallScreen
        ? 12.0
        : isLargeScreen
            ? 24.0
            : 20.0;
    final labelWidth = isSmallScreen ? 100.0 : 120.0;

    final address = order.address.address;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: GoogleFonts.poppins(
            fontSize: fontSizeBase + 4,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.white, size: fontSizeBase + 4),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info Card
            _buildAnimatedCard(
              delay: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Order Information', Icons.receipt_long,
                      sectionTitleSize),
                  SizedBox(height: spacing * 0.6),
                  _buildInfoRow('Order ID', order.id ?? 'N/A',
                      icon: Icons.tag,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  _buildInfoRow('Status', order.orderStatus ?? '---',
                      icon: Icons.info,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth,
                      statusColor: _getStatusColor(order.orderStatus)),
                  _buildInfoRow('Created At', _formatDate(order.orderDate),
                      icon: Icons.calendar_today,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  _buildInfoRow(
                      'Delivered At', _formatDate(order.deliveryCompletedAt),
                      icon: Icons.local_shipping,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  order.paidAt != null
                      ? _buildInfoRow('Paid At', _formatDate(order.paidAt),
                          icon: Icons.wallet_outlined,
                          fontSize: fontSizeBase,
                          labelWidth: labelWidth)
                      : SizedBox.shrink()
                ],
              ),
              radius: cardRadius,
              padding: padding,
            ),
            SizedBox(height: spacing),

            // Customer Info Card
            _buildAnimatedCard(
              delay: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                      'Customer Information', Icons.person, sectionTitleSize),
                  SizedBox(height: spacing * 0.6),
                  _buildInfoRow('Name', order.address.fullName ?? 'N/A',
                      icon: Icons.account_circle,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  _buildInfoRow('Phone', order.address.phone ?? 'N/A',
                      icon: Icons.phone,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  _buildInfoRow(
                    'Address',
                    '${address.ward ?? ''}, ${address.district ?? ''}, ${address.province ?? ''}',
                    icon: Icons.location_on,
                    fontSize: fontSizeBase,
                    labelWidth: labelWidth,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      print("Đang vào user id ${order.userId}");
                      context.pushNamed('userDetail',
                          extra: {'userId': order.userId});
                    },
                    icon: Icon(Icons.person_outline,
                        size: 18, color: Colors.blueAccent),
                    label: Text(
                      "View Information",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.blue.withOpacity(0.05),
                    ),
                  ),
                ],
              ),
              radius: cardRadius,
              padding: padding,
            ),
            SizedBox(height: spacing),

            // Payment Info Card
            _buildAnimatedCard(
              delay: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                      'Payment & Shipping', Icons.payment, sectionTitleSize),
                  SizedBox(height: spacing * 0.6),
                  _buildInfoRow('Payment Method', order.paymentMethod ?? 'N/A',
                      icon: Icons.credit_card,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  _buildInfoRow('Shipping Method', order.shipping ?? 'N/A',
                      icon: Icons.local_shipping,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  _buildInfoRow('Shipping Fee',
                      '${order.shippingFee.toStringAsFixed(0)} đ',
                      icon: Icons.attach_money,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  _buildInfoRow('Discount',
                      '-${order.discountAmount.toStringAsFixed(0)} đ',
                      icon: Icons.discount,
                      fontSize: fontSizeBase,
                      labelWidth: labelWidth),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet,
                          size: 16, color: Colors.grey[700]),
                      SizedBox(width: 16 * 0.8),
                      Text(
                        'Total Amount',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                      Text(
                        FormatCurrency.formatCurrency(order.orderTotal),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 7, 146, 61),
                        ),
                      ),
                    ],
                  ),
                  if (order.notes != null && order.notes!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: spacing * 0.6),
                      child: _buildInfoRow('Notes', order.notes!,
                          icon: Icons.note,
                          fontSize: fontSizeBase,
                          labelWidth: labelWidth),
                    ),
                ],
              ),
              radius: cardRadius,
              padding: padding,
            ),
            SizedBox(height: spacing),

            // Order Items List
            _buildOrderItemsList(
              sectionTitleSize: sectionTitleSize,
              spacing: spacing,
              fontSizeBase: fontSizeBase,
              cardRadius: cardRadius,
              padding: padding,
            ),
            SizedBox(height: spacing),

            // Action Buttons
            LayoutBuilder(
              builder: (context, constraints) {
                final buttonWidth = constraints.maxWidth < 400
                    ? constraints.maxWidth * 0.45
                    : constraints.maxWidth * 0.4;
                return isSmallScreen
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            context,
                            icon: Icons.sms,
                            label: 'Message Customer',
                            color: Colors.green[600]!,
                            onPressed: () =>
                                _sendSms(context, order.address.phone ?? ''),
                            width: constraints.maxWidth * 0.9,
                            padding: buttonPadding,
                            fontSize: fontSizeBase,
                          ),
                          SizedBox(height: spacing * 0.5),
                          _buildActionButton(
                            context,
                            icon: Icons.phone,
                            label: 'Call Customer',
                            color: Colors.green[600]!,
                            onPressed: () =>
                                _callPhone(context, order.address.phone ?? ''),
                            width: constraints.maxWidth * 0.9,
                            padding: buttonPadding,
                            fontSize: fontSizeBase,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            context,
                            icon: Icons.sms,
                            label: 'Message Customer',
                            color: Colors.green[600]!,
                            onPressed: () =>
                                _sendSms(context, order.address.phone ?? ''),
                            width: buttonWidth,
                            padding: buttonPadding,
                            fontSize: fontSizeBase,
                          ),
                          _buildActionButton(
                            context,
                            icon: Icons.phone,
                            label: 'Call Customer',
                            color: Colors.green[600]!,
                            onPressed: () =>
                                _callPhone(context, order.address.phone ?? ''),
                            width: buttonWidth,
                            padding: buttonPadding,
                            fontSize: fontSizeBase,
                          ),
                        ],
                      );
              },
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }
}
