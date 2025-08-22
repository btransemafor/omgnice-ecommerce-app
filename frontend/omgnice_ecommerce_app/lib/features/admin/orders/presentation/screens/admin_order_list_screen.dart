import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/admin/orders/presentation/screens/order_process_sceen_ad.dart';
import 'package:omgnice_ecommerce_app/features/admin/orders/presentation/widgets/admin_order_card.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/pages/order_processing_screen.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ModernStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
//  final String growth;
  final bool isPositive;
  final VoidCallback? onTap;

  const ModernStatsCard(
      {Key? key,
      required this.title,
      required this.value,
      required this.icon,
      required this.bgColor,
      required this.iconColor,
      //  required this.growth,
      required this.isPositive,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final fontSizeBase = isSmallScreen ? 12.0 : 14.0;
    final padding = isSmallScreen ? 12.0 : 16.0;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [bgColor.withOpacity(0.9), bgColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, size: fontSizeBase + 13, color: iconColor),
                  ],
                ),
                // SizedBox(height: padding * 0.1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52),
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: fontSizeBase + 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: fontSizeBase,
                      color: Colors.white.withOpacity(0.9),
                    ),
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

class AdminOrderListScreen extends StatefulWidget {
  const AdminOrderListScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrderListScreen> createState() => _AdminOrderListScreenState();
}

class _AdminOrderListScreenState extends State<AdminOrderListScreen> {
  String _selectedStatusFilter = 'all';
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.fetchAllOrder();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getCardData(List<OrderEntity> orders) {
    final totalOrders = orders.length;
    /* final pendingOrders =
        orders.where((order) => order.orderStatus == 'pending').length; */

    final pendingOrdersCount = orders
    .where((order) =>
        order.orderStatus == 'pending' ||
        order.orderStatus == 'shipping' ||
        order.orderStatus == 'processing')
    .length;

    return [
      {
        'title': 'Total Orders',
        'value': totalOrders.toString(),
        'icon': Icons.shopping_cart_outlined,
        'bgColor': const Color.fromARGB(255, 142, 56, 131)!.withOpacity(0.7),
        'iconColor': Colors.white,
        //   'growth': '+12%', // Replace with actual logic if available
        'isPositive': true,
      },
      {
        'title': 'In Progress',
        'value': pendingOrdersCount.toString(),
        'icon': Icons.hourglass_empty_rounded,
        'bgColor': Colors.blue[700]!.withOpacity(0.9),
        'iconColor': Colors.white,
        //   'growth': '+5%', // Replace with actual logic if available
        'isPositive': true,
      },
    ];
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(
              start: now.subtract(const Duration(days: 30)),
              end: now,
            ),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[700],
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _startDate = null;
      _endDate = null;
      _selectedStatusFilter = 'all';
    });
  }

  List<OrderEntity> _applyFilters(List<OrderEntity> orders) {
    List<OrderEntity> result = orders;

    // Apply status filter
    if (_selectedStatusFilter != 'all') {
      result = result
          .where((order) => order.orderStatus == _selectedStatusFilter)
          .toList();
    }

    // Apply search filter (customer name)
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((order) =>
              (order.address.fullName
                      ?.toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ??
                  false) ||
              (order.id?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false))
          .toList();
    }

    // Apply date range filter
    if (_startDate != null && _endDate != null) {
      result = result.where((order) {
        final orderDate = order.orderDate;
        if (orderDate == null) return false;

        return orderDate
                .isAfter(_startDate!.subtract(const Duration(seconds: 1))) &&
            orderDate.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final orders = orderProvider.order;
        final filteredOrders = _applyFilters(orders);
        final cardData = _getCardData(orders);

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: _showSearchBar
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: fontSizeBase,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by customer name, order ...',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: fontSizeBase,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  )
                : Text(
                    'Manage Orders',
                    style: GoogleFonts.poppins(
                      fontSize: fontSizeBase + 2,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
            centerTitle: !_showSearchBar,
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
            leading: _showSearchBar
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showSearchBar = false;
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                : SizedBox.shrink(),
            actions: [
              if (!_showSearchBar) ...[
                IconButton(
                  icon: Icon(Icons.search,
                      color: Colors.white, size: fontSizeBase + 2),
                  onPressed: () {
                    setState(() {
                      _showSearchBar = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.date_range,
                      color: Colors.white, size: fontSizeBase + 2),
                  onPressed: () => _selectDateRange(context),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_alt,
                      color: Colors.white, size: fontSizeBase + 2),
                  onSelected: (value) {
                    setState(() => _selectedStatusFilter = value);
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'all',
                      child: Text(
                        'All',
                        style: GoogleFonts.poppins(
                            fontSize: fontSizeBase, color: Colors.black87),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'pending',
                      child: Text(
                        'Pending',
                        style: GoogleFonts.poppins(
                            fontSize: fontSizeBase, color: Colors.black87),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'processing',
                      child: Text(
                        'Processing',
                        style: GoogleFonts.poppins(
                            fontSize: fontSizeBase, color: Colors.black87),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'shipping',
                      child: Text(
                        'Shipping',
                        style: GoogleFonts.poppins(
                            fontSize: fontSizeBase, color: Colors.black87),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'completed',
                      child: Text(
                        'Completed',
                        style: GoogleFonts.poppins(
                            fontSize: fontSizeBase, color: Colors.black87),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'cancelled',
                      child: Text(
                        'Cancelled',
                        style: GoogleFonts.poppins(
                            fontSize: fontSizeBase, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active filters display
                if (_searchQuery.isNotEmpty ||
                    _startDate != null ||
                    _selectedStatusFilter != 'all')
                  Container(
                    color: Colors.green[50],
                    padding: EdgeInsets.all(padding * 0.75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Active Filters',
                              style: GoogleFonts.poppins(
                                fontSize: fontSizeBase - 1,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[800],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _clearFilters,
                              icon: Icon(Icons.clear_all,
                                  size: fontSizeBase, color: Colors.red[700]),
                              label: Text(
                                'Clear All',
                                style: GoogleFonts.poppins(
                                  fontSize: fontSizeBase - 2,
                                  color: Colors.red[700],
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: padding * 0.5),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padding * 0.3),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (_searchQuery.isNotEmpty)
                              Chip(
                                label: Text('Name: $_searchQuery'),
                                deleteIcon:
                                    Icon(Icons.close, size: fontSizeBase - 2),
                                onDeleted: () {
                                  setState(() {
                                    _searchQuery = '';
                                    _searchController.clear();
                                  });
                                },
                                backgroundColor: Colors.blue[100],
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: fontSizeBase - 2,
                                  color: Colors.blue[800],
                                ),
                              ),
                            if (_startDate != null && _endDate != null)
                              Chip(
                                label: Text(
                                  'Date: ${_dateFormat.format(_startDate!)} - ${_dateFormat.format(_endDate!)}',
                                ),
                                deleteIcon:
                                    Icon(Icons.close, size: fontSizeBase - 2),
                                onDeleted: () {
                                  setState(() {
                                    _startDate = null;
                                    _endDate = null;
                                  });
                                },
                                backgroundColor: Colors.purple[100],
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: fontSizeBase - 2,
                                  color: Colors.purple[800],
                                ),
                              ),
                            if (_selectedStatusFilter != 'all')
                              Chip(
                                label: Text(
                                    'Status: ${_selectedStatusFilter.toUpperCase()}'),
                                deleteIcon:
                                    Icon(Icons.close, size: fontSizeBase - 2),
                                onDeleted: () {
                                  setState(() {
                                    _selectedStatusFilter = 'all';
                                  });
                                },
                                backgroundColor: Colors.orange[100],
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: fontSizeBase - 2,
                                  color: Colors.orange[800],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Stats Grid
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: padding,
                      mainAxisSpacing: padding,
                      childAspectRatio: isSmallScreen ? 1.4 : 1.2,
                      mainAxisExtent: isSmallScreen
                          ? 120
                          : isLargeScreen
                              ? 160
                              : 140,
                    ),
                    itemCount: cardData.length,
                    itemBuilder: (context, index) {
                      final data = cardData[index];
                      return ModernStatsCard(
                        onTap: () => {
                          if (data['title'] == 'In Progress')
                            {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => OrderProcessScreenAd(),
                                ),
                              ),
                            }
                        },

                        title: data['title'] as String,
                        value: data['value'] as String,
                        icon: data['icon'] as IconData,
                        bgColor: data['bgColor'] as Color,
                        iconColor: data['iconColor'] as Color,
                        //   growth: data['growth'] as String,
                        isPositive: data['isPositive'] as bool,
                      );
                    },
                  ),
                ),

                // Order List Header with counter
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padding, vertical: padding * 0.5),
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
                        '${filteredOrders.length} found',
                        style: GoogleFonts.poppins(
                          fontSize: fontSizeBase,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Order List
                filteredOrders.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(padding),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: padding),
                              Text(
                                'No orders found',
                                style: GoogleFonts.poppins(
                                  fontSize: fontSizeBase,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (_searchQuery.isNotEmpty ||
                                  _startDate != null ||
                                  _selectedStatusFilter != 'all')
                                TextButton(
                                  onPressed: _clearFilters,
                                  child: Text(
                                    'Clear filters',
                                    style: GoogleFonts.poppins(
                                      fontSize: fontSizeBase,
                                      color: Colors.green[700],
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: padding, vertical: padding * 0.3),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return AdminOrderCard(
                            key: ValueKey(order.id), // Ensure unique widgets
                            order: order,
                          );
                        },
                      ),
                SizedBox(height: padding), // Extra padding at bottom
              ],
            ),
          ),
        );
      },
    );
  }
}
