import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';

class ProductCategory {
  final String nameCategory;
  final double soldQuantity;
  final double sale;
  final Color randomColor;

  ProductCategory({
    required this.nameCategory,
    required this.soldQuantity,
    required this.sale,
    required this.randomColor,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      nameCategory: json['name'] ?? 'Unknown',
      soldQuantity: (json['sold_quantity'] as num?)?.toDouble() ?? 0.0,
      sale: (json['total_sale'] as num?)?.toDouble() ?? 0.0,
      randomColor: getRandomColor(),
    );
  }

  static Color getRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }
}

class DrinkSalesStatsPage extends StatefulWidget {
  const DrinkSalesStatsPage({super.key});

  @override
  State<DrinkSalesStatsPage> createState() => _DrinkSalesStatsPageState();
}

class _DrinkSalesStatsPageState extends State<DrinkSalesStatsPage> {
  int touchedIndex = -1;
  String timeFrame = 'Week';
  List<ProductCategory> productCategories = [];
  DateTime? fromDate;
  DateTime? toDate;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetToDefaultDates();
    _fetchData();
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  // Reset to default dates (last week to today)
  void _resetToDefaultDates() {
    setState(() {
      timeFrame = 'Week';
      fromDate = DateTime.now().subtract(const Duration(days: 7));
      toDate = DateTime.now();
      _fromDateController.text = _formatDate(fromDate!);
      _toDateController.text = _formatDate(toDate!);
    });
  }

  // Format DateTime to DD/MM/YYYY
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Update date range based on time frame
  void _updateDateRange() {
    final now = DateTime.now();
    setState(() {
      switch (timeFrame) {
        case 'Day':
          fromDate = DateTime(now.year, now.month, now.day);
          toDate = fromDate;
          break;
        case 'Week':
          fromDate = now.subtract(Duration(days: now.weekday - 1));
          toDate = fromDate!.add(const Duration(days: 6));
          break;
        case 'Month':
          fromDate = DateTime(now.year, now.month, 1);
          toDate = DateTime(now.year, now.month + 1, 0);
          break;
        case 'Year':
          fromDate = DateTime(now.year, 1, 1);
          toDate = DateTime(now.year, 12, 31);
          break;
      }
      _fromDateController.text = _formatDate(fromDate!);
      _toDateController.text = _formatDate(toDate!);
    });
  }

  // Fetch data from API
  Future<void> _fetchData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final queryParams = {
          'from': fromDate!.toIso8601String().split('T').first,
          'to': toDate!.toIso8601String().split('T').first,
        };

        final Dio dio = DioClient().client;
        final response = await dio.get(
          'http://192.168.124.242:8081/api/admin/statistics',
          queryParameters: queryParams,
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          setState(() {
            productCategories = data.map((json) => ProductCategory.fromJson(json)).toList();
            if (productCategories.isEmpty) {
              _resetToDefaultDates();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No data found for selected dates. Reset to default.'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          });
        } else {
          throw Exception('Failed to load data: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          productCategories = [];
          _resetToDefaultDates();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching data: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Reusable Date Picker TextFormField
  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required DateTime? initialDate,
    required Function(DateTime) onDateSelected,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  // Date Filter Form
  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            // From Date
            Expanded(
              child: _buildDateField(
                controller: _fromDateController,
                label: 'From Date',
                initialDate: fromDate,
                onDateSelected: (picked) {
                  setState(() {
                    fromDate = picked;
                    _fromDateController.text = _formatDate(picked);
                    timeFrame = 'Custom'; // Override timeFrame on manual selection
                    if (toDate != null && toDate!.isBefore(fromDate!)) {
                      toDate = fromDate;
                      _toDateController.text = _formatDate(toDate!);
                    }
                    _fetchData();
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            // To Date
            Expanded(
              child: _buildDateField(
                controller: _toDateController,
                label: 'To Date',
                initialDate: toDate,
                onDateSelected: (picked) {
                  setState(() {
                    toDate = picked;
                    _toDateController.text = _formatDate(picked);
                    timeFrame = 'Custom'; // Override timeFrame on manual selection
                    if (fromDate != null && toDate!.isBefore(fromDate!)) {
                      fromDate = toDate;
                      _fromDateController.text = _formatDate(fromDate!);
                    }
                    _fetchData();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Time Frame Selector
  Widget _buildTimeFrameSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF5E35B1),
      child: Row(
        children: [
          const Text(
            'Analytics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text(
                  'Filter by:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: timeFrame,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  underline: Container(),
                  dropdownColor: const Color(0xFF5E35B1),
                  onChanged: (String? newValue) {
                    setState(() {
                      timeFrame = newValue!;
                      _updateDateRange();
                      _fetchData();
                    });
                  },
                  items: <String>['Day', 'Week', 'Month', 'Year', 'Custom']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Popular Drinks Pie Chart
  Widget _buildPopularDrinks() {
    double totalSales = productCategories.fold(0, (sum, item) => sum + item.sale);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Popular Drinks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            productCategories.isEmpty
                ? Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No data available for the selected date range.',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: List.generate(productCategories.length, (i) {
                          final isTouched = i == touchedIndex;
                          final fontSize = isTouched ? 20.0 : 16.0;
                          final radius = isTouched ? 60.0 : 50.0;
                          final percentage = totalSales > 0
                              ? (productCategories[i].sale / totalSales * 100).round()
                              : 0;

                          return PieChartSectionData(
                            color: productCategories[i].randomColor,
                            value: productCategories[i].sale,
                            title: '$percentage%',
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
              children: productCategories.isEmpty
                  ? []
                  : List.generate(productCategories.length, (i) {
                      final percentage = totalSales > 0
                          ? (productCategories[i].sale / totalSales * 100).round()
                          : 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildPieChartIndicator(
                          color: productCategories[i].randomColor,
                          title: productCategories[i].nameCategory,
                          percentage: '$percentage%',
                        ),
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }

  // Pie Chart Indicator
  Widget _buildPieChartIndicator({
    required Color color,
    required String title,
    required String percentage,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E35B1),
        elevation: 0,
        title: const Text(
          'Sales Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTimeFrameSelector(),
            _buildDateFilter(),
            _buildPopularDrinks(),
          ],
        ),
      ),
    );
  }
}