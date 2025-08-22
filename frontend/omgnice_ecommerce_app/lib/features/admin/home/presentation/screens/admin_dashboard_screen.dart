import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/core/di/injection.dart';
import 'package:omgnice_ecommerce_app/core/widgets/shimmer_widget.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/category_category.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/dashboard_entity.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/revenue_by_day.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/usecase/Get_revenue_trend_By_dateRange.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/usecase/get_statistic_category.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/presentation/widgets/dashboard_stats_grid.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/widgets/notification_bell.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/screens/notification_page_admin.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _categoryFormKey = GlobalKey<FormState>();
  final _overviewFormKey = GlobalKey<FormState>();
  //final _orderFormKey = GlobalKey<FormState>();

  // Controllers for category date filter
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  // Controllers for revenue date filter
  final TextEditingController _orderFromDateController =
      TextEditingController();
  final TextEditingController _orderToDateController = TextEditingController();

  // Controller for overviewDate filter
  final TextEditingController _overviewFromDateController =
      TextEditingController();
  final TextEditingController _overviewToDateController =
      TextEditingController();

  // Data state
  List<ProductCategory> categoryData = [];
  List<RevenueByDay> revenueData = [];

  // Date state for category filter
  DateTime? fromDate;
  DateTime? toDate;

  // Date state for revenue filter
  DateTime? _orderFromDate;
  DateTime? _orderToDate;
  int touchedIndex = -1;
  // Date State for Feature Overview
  DateTime? _overviewFromDate;
  DateTime? _overviewToDate;

  // UI state
  bool _isLoading = false;
  String? _selectedOrderFilter;
  List<Map<String, dynamic>> _orderFilterOptions = [];
  String? _lastErrorMessage; // Track the last error message
  bool is_expand = false;

  // Format for displaying dates
  final DateFormat _displayDateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  DashboardEntity? overview;

  get dashboardProvider => null;

  @override
  void initState() {
    super.initState();
    debugPrint('AdminDashboardScreen: initState called');

    // Initialize date values and generate weekly ranges
    _setDefaultDates();
    _generateWeeklyRanges();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      final notificationPro = Provider.of<NotificationProvider>(
        context,
        listen: false,
      ); 

       Provider.of<UserProvider>(context, listen: false)
          .getProfileUser();
      // Fetch notifications for admin

      notificationPro.fetchNotifications(isAdmin: true);
      dashProvider.reload(
        from: _formatDate(_overviewFromDate!),
        to: _formatDate(_overviewToDate!),
      );
      _fetchData(); // Fetch category and revenue data
    });
  }

  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _fromDateController.dispose();
    _toDateController.dispose();
    _orderFromDateController.dispose();
    _orderToDateController.dispose();
    _overviewFromDateController.dispose();
    _overviewToDateController.dispose();
    super.dispose();
  }

  /// Format Date to String for display
  String _formatDate(DateTime date) {
    return _displayDateFormat.format(date);
  }

  /// Set default dates (last week to today)
  void _setDefaultDates() {
    setState(() {
      final now = DateTime.now();

      // Set category filter dates (7 days ago to today)
      fromDate = now.subtract(const Duration(days: 7));
      toDate = now;
      _fromDateController.text = _formatDate(fromDate!);
      _toDateController.text = _formatDate(toDate!);

      // Set order filter dates (same as category for initialization)
      _orderFromDate = fromDate;
      _orderToDate = toDate;
      _orderFromDateController.text = _formatDate(_orderFromDate!);
      _orderToDateController.text = _formatDate(_orderToDate!);

      _overviewFromDate = DateTime(2023);
      _overviewToDate = toDate;
      _overviewFromDateController.text = _formatDate(_overviewFromDate!);
      _overviewToDateController.text = _formatDate(_overviewToDate!);

      debugPrint('Set default dates: from=$fromDate, to=$toDate');
    });
  }

  /// Generate weekly ranges from Jan 1, 2025 to current date
  void _generateWeeklyRanges() {
    final startDate = DateTime(2025, 1, 1); // Start from Jan 1, 2025
    final endDate = DateTime.now(); // Current date: May 6, 2025
    List<Map<String, dynamic>> weeks = [];
    DateTime currentStart = startDate;

    // Generate weekly ranges
    while (currentStart.isBefore(endDate) ||
        currentStart.isAtSameMomentAs(endDate)) {
      DateTime weekEnd = currentStart.add(const Duration(days: 6));
      if (weekEnd.isAfter(endDate)) {
        weekEnd = endDate;
      }
      String weekLabel =
          '${_formatDate(currentStart)} TO ${_formatDate(weekEnd)}';
      weeks.add({
        'label': weekLabel,
        'start': currentStart,
        'end': weekEnd,
      });
      currentStart = weekEnd.add(const Duration(days: 1));
    }

    // Add "Last 7 days" option only if it doesn't already exist
    final last7DaysStart = endDate.subtract(const Duration(days: 6));
    final last7DaysLabel =
        '${_formatDate(last7DaysStart)}   to  ${_formatDate(endDate)}';
    if (!weeks.any((week) => week['label'] == last7DaysLabel)) {
      weeks.insert(0, {
        'label': last7DaysLabel,
        'start': last7DaysStart,
        'end': endDate,
      });
    }

    // Add Custom Range option
    weeks.add({'label': 'Custom Range', 'start': null, 'end': null});

    setState(() {
      _orderFilterOptions = weeks;
      // Default to the last 7 days
      _selectedOrderFilter = last7DaysLabel;
      _orderFromDate = last7DaysStart;
      _orderToDate = endDate;
      _orderFromDateController.text = _formatDate(_orderFromDate!);
      _orderToDateController.text = _formatDate(_orderToDate!);
      // _overviewFromDate = DateTime(2023);
      //  _overviewToDate = DateTime()
    });

    debugPrint('Generated ${_orderFilterOptions.length} weekly ranges');
    debugPrint(
        'Unique labels: ${_orderFilterOptions.map((e) => e['label']).toSet()}');
    debugPrint('Default range: $_selectedOrderFilter');
  }

  /// Fetch category and revenue data
  Future<void> _fetchData() async {
    debugPrint('AdminDashboardScreen: _fetchData called');

    // Validate dates before fetching category data
    if (fromDate == null || toDate == null) {
      debugPrint('Category dates not set');
      return;
    }

    // Validate dates before fetching revenue data
    if (_orderFromDate == null || _orderToDate == null) {
      debugPrint('Revenue dates not set');
      return;
    }

    if (_overviewFromDate == null || _overviewToDate == null) {
      debugPrint('dates not set');
      return;
    }

    setState(() => _isLoading = true);
    _lastErrorMessage = null; // Reset error message

    try {
      // Fetch dashboard overview
      final dashProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      // Fetch dashboard overview with overview dates
      await dashProvider.fetchDashboardData(
        from: _formatDate(_overviewFromDate!),
        to: _formatDate(_overviewToDate!),
      );

      debugPrint('Dashboard data: ${dashProvider.dashboardData}');
      // Fetch category statistics
      debugPrint(
          'Fetching category data: from=${_apiDateFormat.format(fromDate!)}, to=${_apiDateFormat.format(toDate!)}');
      final categoryUseCase = sl<GetStatisticCategory>();
      final categoryResult = await categoryUseCase.execute(fromDate!, toDate!);
      debugPrint('Received category data: ${categoryResult.length} items');

      // Fetch revenue trend
      debugPrint(
          'Fetching revenue data: start=${_apiDateFormat.format(_orderFromDate!)}, end=${_apiDateFormat.format(_orderToDate!)}');
      final revenueUseCase = sl<GetRevenueTrendByDaterange>();
      final revenueResult =
          await revenueUseCase.execute(_orderFromDate!, _orderToDate!);
      debugPrint('Received revenue data: ${revenueResult.length} items');

      setState(() {
        categoryData = categoryResult;
        revenueData = revenueResult;

        // Show notifications if no data was found
        if (categoryData.isEmpty) {
          _showNotification(
              'Không tìm thấy dữ liệu danh mục cho khoảng thời gian đã chọn.');
        }
        if (revenueData.isEmpty) {
          //   _showNotification('Không tìm thấy dữ liệu doanh thu theo ngày.');
        }
      });
    } catch (e, stackTrace) {
      debugPrint('Fetch error: $e\n$stackTrace');
      if (e is DioException && e.response != null) {
        debugPrint('Server response: ${e.response!.data}');
      }

      setState(() {
        categoryData = categoryData; // Keep existing category data
        revenueData = [];
        _lastErrorMessage = 'Error while retrieving revenue data';
      });

      _showNotification('Lỗi khi lấy dữ liệu: $e');
    } finally {
      setState(() => _isLoading = false);
      debugPrint('Fetch completed, isLoading: $_isLoading');
    }
  }

  /// Show notification to user
  void _showNotification(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Build reusable date picker field
  Widget _buildDateField(
      {required TextEditingController controller,
      required String label,
      required DateTime initDate,
      required Function(DateTime) onDateSelected,
      Color? backgroundColor,
      Color? textColor,
      Color? borderColor,
      Color? iconColor,
      bool hasIcon = true}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: borderColor ?? Colors.grey[300]!,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: borderColor ?? Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          suffixIcon: hasIcon
              ? Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: iconColor ?? Theme.of(context).primaryColor,
                )
              : null,
          filled: true,
          fillColor: backgroundColor ?? Colors.grey[50],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          isDense: true,
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            firstDate: DateTime(2023),
            lastDate: DateTime(2026),
            initialDate: initDate,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            debugPrint('Date picked: $picked');
            onDateSelected(picked);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng chọn một ngày';
          }
          return null;
        },
      ),
    );
  }

  /// Build date filter form for category data
  Widget _buildCategoryDateFilter() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _categoryFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contribute Shared By Category',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // From Date
                Expanded(
                  child: _buildDateField(
                    controller: _fromDateController,
                    label: 'From Date',
                    initDate: fromDate!,
                    onDateSelected: (value) {
                      setState(() {
                        fromDate = value;
                        _fromDateController.text = _formatDate(fromDate!);

                        // Ensure from date is not after to date
                        if (toDate != null && toDate!.isBefore(fromDate!)) {
                          toDate = fromDate;
                          _toDateController.text = _formatDate(toDate!);
                        }
                        debugPrint('Category from date selected: $fromDate');
                      });
                      _fetchData();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // To Date
                Expanded(
                  child: _buildDateField(
                    controller: _toDateController,
                    label: 'To Date',
                    initDate: toDate!,
                    onDateSelected: (value) {
                      setState(() {
                        toDate = value;
                        _toDateController.text = _formatDate(toDate!);

                        // Ensure to date is not before from date
                        if (fromDate != null && toDate!.isBefore(fromDate!)) {
                          fromDate = toDate;
                          _fromDateController.text = _formatDate(fromDate!);
                        }
                        debugPrint('Category to date selected: $toDate');
                      });
                      _fetchData();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _reloadDashboard(DateTime from, DateTime to) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<DashboardProvider>().reload(
              from: _apiDateFormat.format(from), // Use yyyy-MM-dd
              to: _apiDateFormat.format(to), // Use yyyy-MM-dd
            );
      }
    });
  }

  Widget _buildOverviewDateFilter() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Form(
          key: _overviewFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  // From Date
                  Expanded(
                    child: _buildDateField(
                      hasIcon: false,
                      controller: _overviewFromDateController,
                      label: 'From Date',
                      initDate: _overviewFromDate ?? DateTime.now(),
                      onDateSelected: (value) {
                        setState(() {
                          _overviewFromDate = value;
                          _overviewFromDateController.text =
                              _formatDate(value); // dd-MM-yyyy for UI

                          // Ensure from date is not after to date
                          if (_overviewToDate != null &&
                              _overviewToDate!.isBefore(value)) {
                            _overviewToDate = value;
                            _overviewToDateController.text = _formatDate(value);
                          }
                          debugPrint(
                              'OVERVIEW from date selected: $_overviewFromDate');
                        });
                        _reloadDashboard(_overviewFromDate!, _overviewToDate!);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // To Date
                  Expanded(
                    child: _buildDateField(
                      hasIcon: false,
                      controller: _overviewToDateController,
                      label: 'To Date',
                      initDate: _overviewToDate ?? DateTime.now(),
                      onDateSelected: (value) {
                        setState(() {
                          _overviewToDate = value;
                          _overviewToDateController.text =
                              _formatDate(value); // dd-MM-yyyy for UI

                          // Ensure to date is not before from date
                          if (_overviewFromDate != null &&
                              value.isBefore(_overviewFromDate!)) {
                            _overviewFromDate = value;
                            _overviewFromDateController.text =
                                _formatDate(value);
                          }
                          debugPrint(
                              'OVERVIEW to date selected: $_overviewToDate');
                        });
                        _reloadDashboard(_overviewFromDate!, _overviewToDate!);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  /// Build order filter with weekly ranges
  Widget _buildOrderFilter(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Trend Last 7 Days',
            style: TextStyle(
              fontSize: size.width * 0.044,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: size.height * 0.05,
                  margin: const EdgeInsets.only(right: 70),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Tăng độ đệm để tạo không gian thoáng
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20), // Bo tròn nhiều hơn
                    border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.5), // Viền mỏng, mềm mại hơn
                    color: Colors.white, // Sử dụng nền trắng cho sự sang trọng
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.2), // Hiệu ứng đổ bóng nhẹ
                        blurRadius: 8, // Làm mờ bóng
                        offset: Offset(0, 4), // Vị trí đổ bóng
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Canh giữa cả theo chiều ngang
                    children: [
                      Icon(
                        Icons
                            .filter_list, // Thêm icon lọc để tăng tính tương tác
                        color: const Color.fromARGB(
                            255, 16, 74, 68), // Màu icon đẹp và dễ nhìn
                        size: size.height * 0.02, // Kích thước icon
                      ),
                      const SizedBox(width: 8), // Khoảng cách giữa icon và text
                      Text(
                        '$_selectedOrderFilter',
                        style: TextStyle(
                          fontSize: size.width * 0.035, // Kích thước chữ dễ đọc
                          fontWeight:
                              FontWeight.w600, // Mặc định đậm để nổi bật hơn
                          color: const Color.fromARGB(255, 137, 75,
                              0), // Màu chữ tương thích với màu icon
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Generate FlSpot list for the revenue trend chart
  List<FlSpot> _generateSpots() {
    if (_orderFromDate == null || _orderToDate == null || revenueData.isEmpty) {
      return [];
    }

    // Calculate the number of days in the range
    final daysInRange = _orderToDate!.difference(_orderFromDate!).inDays + 1;
    if (daysInRange <= 0) return [];

    // Create a list to store spots (x: day index, y: revenue)
    List<FlSpot> spots = [];

    // Iterate through each day in the range
    for (int i = 0; i < daysInRange; i++) {
      final currentDate = _orderFromDate!.add(Duration(days: i));
      final formattedDate = _apiDateFormat.format(currentDate);

      // Find the revenue for this date in revenueData
      final revenueEntry = revenueData.firstWhere(
        (entry) => entry.date == formattedDate,
        orElse: () => RevenueByDay(date: formattedDate, totalRevenue: 0),
      );

      // Add the spot (x: index, y: totalRevenue)
      spots.add(FlSpot(i.toDouble(), revenueEntry.totalRevenue.toDouble()));
    }

    return spots;
  }

  /// Calculate maxY and interval for the y-axis dynamically
  Map<String, double> _calculateChartBounds() {
    if (revenueData.isEmpty) {
      return {'maxY': 200000, 'interval': 50000};
    }

    // Find the maximum revenue
    final maxRevenue = revenueData.fold<double>(
      0,
      (max, entry) =>
          entry.totalRevenue > max ? entry.totalRevenue.toDouble() : max,
    );

    // Set maxY to 120% of maxRevenue for padding
    final maxY = maxRevenue * 1.2;

    // Calculate interval (aim for 4-6 intervals on the y-axis)
    final interval = (maxY / 5).ceilToDouble();

    return {'maxY': maxY, 'interval': interval};
  }

  /// Build the revenue trend chart with dynamic data
  Widget _buildRevenueTrend() {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: ShimmerWidget.rectangular(height: 200),
        ),
      );
    }

    // If no data, show message or error
    if (revenueData.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Colors.amber[600],
                size: 50,
              ),
              const SizedBox(width: 8),
              Text(
                _lastErrorMessage ?? 'No Data ',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final spots = _generateSpots();
    final chartBounds = _calculateChartBounds();
    final maxY = chartBounds['maxY']!;
    final interval = chartBounds['interval']!;

    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      padding: const EdgeInsets.only(left: 10, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      // Trục YYYYYY
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= spots.length)
                          return Container();

                        // Calculate the date for this index
                        final date = _orderFromDate!.add(Duration(days: index));
                        const dayLabels = [
                          'Sun',
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thur',
                          'Fri',
                          'Sat'
                        ];
                        final dayOfWeek = date.weekday %
                            7; // 0 (Sun) to 6 (Sat) in Vietnamese format

                        return SideTitleWidget(
                          space: 8,
                          meta: meta,
                          child: Text(
                            dayLabels[dayOfWeek],
                            style: GoogleFonts.poppins(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      // Dãn trục x
                      reservedSize: 39,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();

                        // Format currency in Vietnamese style
                        final formatter = NumberFormat.compact(locale: 'vi');
                        return SideTitleWidget(
                          space: 5,
                          meta: meta,
                          child: Text(
                            '${formatter.format(value)}',
                            style: GoogleFonts.poppins(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    // tooltipBgColor: Theme.of(context).primaryColor.withOpacity(0.8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final index = touchedSpot.x.toInt();
                        final date = _orderFromDate!.add(Duration(days: index));

                        // Format date and revenue for tooltip
                        final dateStr = _displayDateFormat.format(date);
                        final revenueStr =
                            NumberFormat.currency(locale: 'vi', symbol: '₫')
                                .format(touchedSpot.y);

                        return LineTooltipItem(
                          '$dateStr\n$revenueStr',
                          GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                minX: 0,
                maxX: (spots.length - 1).toDouble(),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Theme.of(context).primaryColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.3),
                          Theme.of(context).primaryColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Summary statistics
          if (revenueData.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildRevenueSummary(),
          ],
        ],
      ),
    );
  }

  /// Build revenue summary statistics (total, average, highest day)
  Widget _buildRevenueSummary() {
    // Calculate total revenue
    final totalRevenue = revenueData.fold<double>(
      0,
      (sum, entry) => sum + entry.totalRevenue,
    );

    // Calculate average daily revenue
    final daysWithData = revenueData.length;
    final averageRevenue = daysWithData > 0 ? totalRevenue / daysWithData : 0;

    // Find the day with the highest revenue
    RevenueByDay? highestDay;
    if (revenueData.isNotEmpty) {
      highestDay =
          revenueData.reduce((a, b) => a.totalRevenue > b.totalRevenue ? a : b);
    }

    // Format numbers for display
    final formatter = FormatCurrency.formatCurrency(totalRevenue);
    final totalStr = FormatCurrency.formatCurrency(totalRevenue);
    final avgStr = FormatCurrency.formatCurrency(averageRevenue);
    final highestStr = highestDay != null
        ? FormatCurrency.formatCurrency(highestDay!.totalRevenue)
        : 'N/A';
    final highestDateStr = highestDay != null
        ? _displayDateFormat.format(DateTime.parse(highestDay.date))
        : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: EdgeInsets.only(bottom: 50),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Total Revenue:', totalStr),
              const SizedBox(height: 8),
              _buildSummaryRow('Average Daily Revenue:', avgStr),
              const SizedBox(height: 10),
              _buildSummaryRow(
                'Highest Day [$highestDateStr]:',
                highestStr,
                highlight: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a single row for the summary statistics
  Widget _buildSummaryRow(String label, String value,
      {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: highlight ? 16 : 15,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
            color: highlight ? Theme.of(context).primaryColor : Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Build category data display
  Widget _buildCategoryDataDisplay() {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: ShimmerWidget.rectangular(
            height: 200,
          ),
        ),
      );
    }

    if (categoryData.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'There is no category data for the selected time period.',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return is_expand
        ? AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              margin: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 24, top: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Category Performance',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(7),
                      child: Column(
                        children: [
                          ...categoryData.asMap().entries.map((entry) {
                            int index = entry.key;
                            var category = entry.value;
                            bool isLast = index == categoryData.length - 1;

                            return AnimatedContainer(
                              duration:
                                  Duration(milliseconds: 200 + (index * 50)),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 14),
                                        // Category Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                category.nameCategory,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade800,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.inventory_2_outlined,
                                                    size: 14,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${category.soldQuantity} items sold',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Sales Amount
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.green.shade400,
                                                Colors.green.shade600,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              /*    Icon(
                                                Icons.attach_money,
                                                color: Colors.white,
                                                size: 16,
                                              ), */
                                              Text(
                                                FormatCurrency.formatCurrency(
                                                    category.sale),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isLast) const SizedBox(height: 12),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildPopularDrinks() {
    // Tính xem có dữ liệu sau khi fetch về trong khoảng thời gian đó không ?
    double totalSales = 0;
    for (var item in categoryData) {
      totalSales += item.sale;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
            //
            children: [
              const SizedBox(
                width: 10,
              ),
              categoryData.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No data available for the selected date range.',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: List.generate(categoryData.length, (i) {
                            final isTouched = i == touchedIndex;
                            final fontSize = isTouched ? 20.0 : 16.0;
                            final radius = isTouched ? 60.0 : 50.0;
                            final percentage = totalSales > 0
                                ? (categoryData[i].sale / totalSales * 100)
                                    .round()
                                : 0;

                            return PieChartSectionData(
                              color: categoryData[i].randomColor,
                              value: categoryData[i].sale,
                              title: percentage >= 8
                                  ? '$percentage%'
                                  : '', // Ẩn % nếu < 8
                              radius: radius,
                              titleStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Column(
                children: categoryData.isEmpty
                    ? []
                    : List.generate(categoryData.length, (i) {
                        final percentage = totalSales > 0
                            ? (categoryData[i].sale / totalSales * 100).round()
                            : 0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _buildPieChartIndicator(
                            color: categoryData[i].randomColor,
                            title: categoryData[i].nameCategory,
                            percentage: '$percentage%',
                          ),
                        );
                      }),
              ),
            ]),
      ),
    );
  }

// Pie Chart Indicator
  Widget _buildPieChartIndicator({
    required Color color,
    required String title,
    required String percentage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              percentage,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        title: Text(
          'Sales Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 14 + 2,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          // Updated notification bell with animation
          NotificationBellWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsPageAdmin()),
              );
            },
          ),

          IconButton(
            onPressed: () {
              context.pushNamed('settingScreen');
            },
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            tooltip: 'Settings', // Accessibility improvement
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        displacement: 50,
        edgeOffset: 0,
        color: const Color.fromARGB(255, 10, 154, 10),
        strokeWidth: 2.0,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,

        backgroundColor: Colors.white, // nền phía sau vòng xoay

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Ensures the RefreshIndicator works
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    if (_isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: 6,
                          ),
                        ),
                      );
                    }

                    if (_lastErrorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading dashboard data',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(_lastErrorMessage ?? 'Unknown error'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchData,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink(); // No loading or error state
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Overview",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(child: _buildOverviewDateFilter()),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),

                // Dashboard stats grid with consumer
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    final overview = provider.dashboardData;

                    // Handle null data
                    if (overview == null) {
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'No dashboard data available',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    // Return the grid with data
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child:
                                  DashboardStatsGrid(dashboardData: overview)),
                        ],
                      ),
                    );
                  },
                ),

                // Rest of your dashboard widgets
                _buildCategoryDateFilter(),
                _buildPopularDrinks(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 8),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            is_expand = !is_expand;
                          });
                        },
                        child: Row(children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.only(left: size.width * 0.45),
                              child: Icon(
                                is_expand
                                    ? Icons.keyboard_arrow_down_outlined
                                    : Icons.keyboard_arrow_up_outlined,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ])),
                  ),
                ),
                _buildCategoryDataDisplay(),
                _buildOrderFilter(context),
                _buildRevenueTrend(),

                // Add bottom padding to ensure all content is visible
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
