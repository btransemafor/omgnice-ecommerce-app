// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/features/admin/customers/presentation/screens/user_order_screen.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final Map<String, String> roleMap = {
  '2': 'Admin',
  '1': 'User',
};

final Map<String, String> roleIdMap = {
  'Admin': '2',
  'User': '1',
};

class UserDetailScreen extends StatefulWidget {
  final String userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String currentRole = 'User';
  bool? isActive;
  UserEntity? user;
  List<OrderEntity> orderUser = [];
  bool isLoading = true;
  String? diaChi;
  AddressEntity? _addressesDefault;

  // Refined color scheme
  static const primaryColor = Color(0xFF1E88E5);
  static const accentColor = Color(0xFF26A69A);
  static const surfaceColor = Color(0xFFFAFBFC);
  static const cardColor = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserProvider>();
      final orderProvider = context.read<OrderProvider>();
      final addressProvider = context.read<AddressProvider>();
      final promotionProvider = context.read<PromotionProvider>();

      await userProvider.getProfileUser(widget.userId);
      setState(() {
        user = userProvider.user;
        isActive = user?.isActive ?? false;
        currentRole = roleMap[user?.roleId?.toString()] ?? 'User';
      });

      orderUser = orderProvider.filterUserOrderByUserId(widget.userId);
      await addressProvider.fetchListAddress(widget.userId);
      _addressesDefault = addressProvider.defaultAddress();
      await promotionProvider.fetchPrivatePromotions();
      diaChi = _addressesDefault != null && _addressesDefault!.address != null
          ? '${_addressesDefault!.address!.ward}, ${_addressesDefault!.address!.district}, ${_addressesDefault!.address!.province}, ${_addressesDefault!.address!.details}'
          : 'No address provided';

      setState(() {
        isLoading = false;
      });
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: _buildAppBar(),
      body: isLoading ? _buildLoadingState() : _buildContent(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'User Profile'.tr(),
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.green,
      elevation: 0,
      toolbarHeight: 56,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          onPressed: () => showGiftVoucherBottomSheet(context),
          icon: const Icon(Icons.card_giftcard_outlined,
              color: Colors.white, size: 20),
          tooltip: 'Give gift'.tr(),
        ),
        IconButton(
          onPressed: _showDeleteDialog,
          icon: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
          tooltip: 'Delete User'.tr(),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: accentColor,
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeaderCard(),
              const SizedBox(height: 20),
              _buildQuickStatsSection(),
              const SizedBox(height: 20),
              _buildControlsSection(),
              const SizedBox(height: 20),
              _buildRecentOrdersSection(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      context,
                      color: Colors.green,
                      label: 'Message'.tr(),
                      width: size * 0.4,
                      icon: Icons.message_outlined,
                      padding: 10,
                      fontSize: size * 0.035,
                      onPressed: () => _sendSms(context, user?.phone ?? '113'),
                    ),
                    SizedBox(width: size * 0.05),
                    _buildActionButton(
                      context,
                      color: Colors.green,
                      label: 'Make Call'.tr(),
                      width: size * 0.4,
                      icon: Icons.call_end_outlined,
                      padding: 10,
                      fontSize: size * 0.035,
                      onPressed: () =>
                          _callPhone(context, user?.phone ?? '113'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendSms(BuildContext context, String phoneNumber) async {
    final message =
        Uri.encodeComponent('Hello, please confirm the details of this order.');
    final uri = Uri.parse('sms:$phoneNumber?body=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open SMS app.'.tr(),
              style: GoogleFonts.inter(fontSize: 13)),
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
          content: Text('Unable to make a call.'.tr(),
              style: GoogleFonts.inter(fontSize: 13)),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
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
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeaderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                _buildUserAvatar(),
                const SizedBox(width: 16),
                Expanded(child: _buildUserInfo()),
              ],
            ),
            const SizedBox(height: 16),
            _buildUserDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    final isValidAvatar = user != null &&
        user!.avatar != null &&
        user!.avatar!.isNotEmpty &&
        Uri.tryParse(user!.avatar!)?.hasAbsolutePath == true;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: accentColor.withOpacity(0.2), width: 2),
      ),
      child: ClipOval(
        child: isValidAvatar
            ? Image.network(
                user!.avatar!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Image.asset('assets/avatar_placeholder.jpg',
                      fit: BoxFit.cover);
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Failed to load avatar: $error');
                  return Image.asset('assets/avatar_default.jpg',
                      fit: BoxFit.cover);
                },
              )
            : Image.asset('assets/avatar_default.jpg', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user?.name ?? 'Unknown User'.tr(),
          style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900]),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? 'No email provided'.tr(),
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        _buildVerificationBadges(),
      ],
    );
  }

  Widget _buildVerificationBadges() {
    return Row(
      children: [
        _buildCompactBadge('Email Verified'.tr(), accentColor),
        const SizedBox(width: 8),
        _buildCompactBadge('Phone Verified'.tr(), Colors.blue[600]!),
      ],
    );
  }

  Widget _buildCompactBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }

  Widget _buildUserDetails() {
    return Column(
      children: [
        _buildDetailRow(
            Icons.phone_outlined, user?.phone ?? 'No phone provided'.tr()),
        const SizedBox(height: 8),
        _buildDetailRow(
            Icons.location_on_outlined, diaChi ?? 'No address provided'.tr()),
        const SizedBox(height: 8),
        _buildDetailRow(
          Icons.calendar_today_outlined,
          user?.createdAt != null
              ? 'Joined: ${user!.createdAt!.toLocal().toString().split(' ')[0]}'
                  .tr()
              : 'Joined: Unknown'.tr(),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsSection() {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats'.tr(),
          style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900]),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildCompactStatCard(
                title: 'Orders'.tr(),
                value: user?.userstats?.totalQuantityOrder.toString() ?? '0',
                icon: Icons.shopping_bag_outlined,
                color: accentColor,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildCompactStatCard(
                title: 'Total Spent'.tr(),
                value: user != null && user!.userstats != null
                    ? NumberFormat.compact(locale: 'en')
                        .format(user!.userstats!.totalSpending)
                    : '0đ',
                icon: Icons.account_balance_wallet_outlined,
                color: Colors.green[600]!,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildCompactStatCard(
                title: 'Loyalty Points'.tr(),
                value: '${user?.point ?? 0}',
                icon: Icons.stars_outlined,
                color: Colors.orange[600]!,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildCompactStatCard(
                title: 'Cancel Rate'.tr(),
                value:
                    '${user?.userstats?.cancelRate?.toStringAsFixed(2) ?? '0.00'}%',
                icon: Icons.cancel_outlined,
                color: Colors.red[400]!,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildCompactStatCard(
                title: 'Cancel Order'.tr(),
                value: '${user?.userstats?.cancelledOrders ?? 0}',
                icon: Icons.cancel_presentation_outlined,
                color: Colors.red[400]!,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildCompactStatCard(
                title: 'Average Per Order'.tr(),
                value: FormatCurrency.formatCurrency(
                    user?.userstats?.averageSpending ?? 0),
                icon: Icons.calculate,
                color: const Color.fromARGB(255, 6, 6, 155),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900]),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildControlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Controls'.tr(),
          style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1)),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _buildRoleControl()),
              const SizedBox(width: 20),
              Expanded(child: _buildStatusControl()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role'.tr(),
          style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600]),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[50],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentRole,
              isExpanded: true,
              icon: Icon(Icons.expand_more, color: Colors.grey[600], size: 18),
              style: GoogleFonts.inter(
                color: Colors.grey[900],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              items: ['User', 'Admin'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role.tr()));
              }).toList(),
              onChanged: (newRole) {
                if (newRole != null && newRole != currentRole) {
                  _showRoleConfirmDialog(newRole);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status'.tr(),
          style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600]),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Transform.scale(
              scale: 0.8,
              child: Switch.adaptive(
                value: isActive ?? false,
                onChanged: (newStatus) => _showBlockConfirmDialog(newStatus),
                activeColor: Colors.green,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive == true
                    ? accentColor.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive == true ? 'Active'.tr() : 'Blocked'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive == true ? accentColor : Colors.red[700],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentOrdersSection() {
    final recentOrders = orderUser.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders'.tr(),
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900]),
            ),
            if (orderUser.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UserOrdersScreen(allOrders: orderUser)),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All'.tr(),
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: accentColor,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: accentColor),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1)),
            ],
          ),
          child: recentOrders.isEmpty
              ? _buildEmptyOrdersState()
              : Column(
                  children: recentOrders.asMap().entries.map((entry) {
                    return _buildCompactOrderItem(entry.value,
                        isLast: entry.key == recentOrders.length - 1);
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyOrdersState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.shopping_bag_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No orders yet'.tr(),
            style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactOrderItem(OrderEntity order, {bool isLast = false}) {
    final statusColor = _getStatusColor(order.orderStatus ?? '');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.receipt_outlined, color: statusColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}'.tr(),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.grey[900]),
                ),
                const SizedBox(height: 2),
                Text(
                  order.orderDate?.toLocal().toString().split(' ')[0] ??
                      'Unknown date'.tr(),
                  style:
                      GoogleFonts.inter(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${order.orderTotal?.toStringAsFixed(0) ?? '0'}đ',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey[900]),
              ),
              const SizedBox(height: 2),
              _buildCompactStatusBadge(order.orderStatus ?? '', statusColor),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green[600]!;
      case 'pending':
        return Colors.orange[600]!;
      case 'cancelled':
        return Colors.red[600]!;
      case 'processing':
        return Colors.blue[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildCompactStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.tr(),
        style: GoogleFonts.inter(
            color: color, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _showEditDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit functionality coming soon'.tr(),
            style: GoogleFonts.inter(fontSize: 13)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: accentColor,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

// Bottom Sheet for Vouchers and Gifts
  void showGiftVoucherBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5, // Initial height (50% of screen)
        minChildSize: 0.3, // Minimum height (30% of screen)
        maxChildSize: 0.9, // Maximum height (90% of screen)
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title with gift icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 20, 245, 50)!,
                              const Color.fromARGB(255, 7, 114, 57)!
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 35, 82, 18)
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.redeem_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Vouchers & Gifts',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Select a voucher or send a gift to customers',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Voucher List
                  Consumer<PromotionProvider>(

                    builder: (context, promotionProvider, child) {
                      // Debugging: Print number of promotions
                     // if (promotionProvider.)
                      print(
                          'Number of vouchers: ${promotionProvider.privatePromotions.length}');
                      if (promotionProvider.privatePromotions.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'No vouchers available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                      return Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: promotionProvider.privatePromotions.length,
                          itemBuilder: (context, index) {
                            final voucher =
                                promotionProvider.privatePromotions[index];
                            return Card(
                              color: Colors.white,
                              elevation: 1,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.local_offer_rounded,
                                  color: Color.fromARGB(255, 39, 176, 71),
                                ),
                                title: Text(
                                  voucher.code ?? 'No code',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  voucher.description ?? 'No description',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: ElevatedButton(
                                  // SEND PROMOTION CHO USER
                                  onPressed: () async {
                                    print("Đã nhấn vào send!");
                                    bool isSuccess = await promotionProvider
                                        .sendPromotionForUser(
                                            voucher.id!, widget.userId, );

                                    if (isSuccess) {
                                      // ignore: prefer_interpolation_to_compose_strings
                                      print("Sent voucher to user " +
                                          widget.userId +
                                          " successfully");
                                      SuccessHelper.showSuccess(context,
                                          "Voucher sent successfully, you rock!");
                                    } else {
                                      ErrorHelper.showError(context,
                                          "User has already received this voucher");
                                    }
                                  },
                                  // Disable button if voucher is not active
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 39, 176, 71),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Send',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Close',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  // Bottom padding for safe area
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete User'.tr(),
            style:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text(
          'Are you sure you want to delete this user? This action cannot be undone.'
              .tr(),
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr(),
                style:
                    GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                await context
                    .read<UserProvider>()
                    .deleteUser(userProvider.user!.id);
                print("Xoa USER ------------${user!.id}");
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User deleted successfully'.tr(),
                        style: GoogleFonts.inter(fontSize: 13)),
                    backgroundColor: const Color.fromARGB(255, 15, 107, 44),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'.tr(),
                        style: GoogleFonts.inter(fontSize: 13)),
                    backgroundColor: Colors.red[600],
                    duration: const Duration(seconds: 2),
                    margin: const EdgeInsets.all(16),
                    behavior: SnackBarBehavior.floating, // Thêm thuộc tính này
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete'.tr(), style: GoogleFonts.inter(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _showRoleConfirmDialog(String newRole) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change Role'.tr(),
            style:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text(
          'Are you sure you want to change the user role to "$newRole"?'.tr(),
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr(),
                style:
                    GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final newRoleId = roleIdMap[newRole]!;
                await context
                    .read<UserProvider>()
                    .updateUserInfo({'role_id': newRoleId}, widget.userId);
                setState(() {
                  currentRole = newRole;
                });
                context.read<UserProvider>().fetchAllUsers();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User role changed to $newRole'.tr(),
                        style: GoogleFonts.inter(fontSize: 13)),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: accentColor,
                    duration: const Duration(seconds: 2),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'.tr(),
                        style: GoogleFonts.inter(fontSize: 13)),
                    backgroundColor: Colors.red[600],
                    duration: const Duration(seconds: 2),
                    margin: const EdgeInsets.all(16),
                    behavior: SnackBarBehavior.floating, // Thêm thuộc tính này
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Confirm'.tr(), style: GoogleFonts.inter(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _showBlockConfirmDialog(bool newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          newStatus ? 'Activate Account'.tr() : 'Block Account'.tr(),
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to ${newStatus ? 'activate' : 'block'} this user?'
              .tr(),
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr(),
                style:
                    GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              _showStatusChangeDialog(newStatus);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 13, 37, 255),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Confirm'.tr(), style: GoogleFonts.inter(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(bool newStatus) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final update = {'is_active': newStatus.toString()};
    try {
      final isSuccess = await userProvider.updateUserInfo(update, user!.id);
      if (isSuccess) {
        setState(() {
          isActive = newStatus;
        });
        await userProvider.getProfileUser(user!.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User status changed to ${newStatus ? 'Active' : 'Blocked'}'.tr(),
              style: GoogleFonts.inter(fontSize: 13),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color.fromARGB(255, 28, 111, 37),
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      setState(() {
        isActive = !newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You cannot block your own account.'.tr(),
              style: TextStyle(fontSize: 13)),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16), // Nếu dùng margin thì nhớ behavior
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
