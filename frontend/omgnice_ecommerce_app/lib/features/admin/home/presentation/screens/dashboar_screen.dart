import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DrinkSalesStatsPage extends StatefulWidget {
  const DrinkSalesStatsPage({super.key});

  @override
  State<DrinkSalesStatsPage> createState() => _DrinkSalesStatsPageState();
}

class _DrinkSalesStatsPageState extends State<DrinkSalesStatsPage> {
  int touchedIndex = -1;
  String timeFrame = 'Week'; // 'Day', 'Week', 'Month', 'Year'

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
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement notifications functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications clicked')),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications', // Accessibility improvement
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement settings functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings clicked')),
              );
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings', // Accessibility improvement
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTimeFrameSelector(),
            _buildOverviewCards(),
            _buildRevenueTrend(),
            _buildPopularDrinks(),
            _buildCustomerSegments(),
            _buildWeeklyPerformanceChart(),
          ],
        ),
      ),
    );
  }

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
                    });
                  },
                  items: <String>['Day', 'Week', 'Month', 'Year']
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

  Widget _buildOverviewCards() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildInfoCard(
                title: 'Total Sales',
                value: '₫8,459,000',
                change: '+15.3%',
                icon: Icons.attach_money,
                iconColor: Colors.green,
                isPositive: true,
              ),
              _buildInfoCard(
                title: 'Orders',
                value: '486',
                change: '+8.2%',
                icon: Icons.shopping_bag,
                iconColor: Colors.blue,
                isPositive: true,
              ),
              _buildInfoCard(
                title: 'Avg. Order Value',
                value: '₫17,406',
                change: '+5.7%',
                icon: Icons.receipt_long,
                iconColor: Colors.amber,
                isPositive: true,
              ),
              _buildInfoCard(
                title: 'Customers',
                value: '124',
                change: '-2.1%',
                icon: Icons.people,
                iconColor: Colors.red,
                isPositive: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color iconColor,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTrend() {
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
            Row(
              children: [
                const Text(
                  'Revenue Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    // TODO: Implement export functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting data...')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E35B1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.download_outlined,
                          color: Color(0xFF5E35B1),
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Export',
                          style: TextStyle(
                            color: Color(0xFF5E35B1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50000,
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
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          );
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Mon';
                              break;
                            case 1:
                              text = 'Tue';
                              break;
                            case 2:
                              text = 'Wed';
                              break;
                            case 3:
                              text = 'Thu';
                              break;
                            case 4:
                              text = 'Fri';
                              break;
                            case 5:
                              text = 'Sat';
                              break;
                            case 6:
                              text = 'Sun';
                              break;
                            default:
                              return Container();
                          }
                          return SideTitleWidget(
                            space: 8,
                            meta: meta,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 50000,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox();
                          return SideTitleWidget(
                            space: 8,
                            meta: meta,
                            child: Text(
                              '₫${(value / 1000).round()}K',
                              style: const TextStyle(
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
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                            '₫${NumberFormat("#,###").format(touchedSpot.y.toInt())}',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 200000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 95000),
                        FlSpot(1, 130000),
                        FlSpot(2, 110000),
                        //FlSpot(3, 150000),
                       // FlSpot(4, 180000),
                        //FlSpot(5, 145000),
                       // FlSpot(6, 190000),
                      ],
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5E35B1), Color(0xFF7F57C2)],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF5E35B1).withOpacity(0.2),
                            const Color(0xFF5E35B1).withOpacity(0.0),
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
          ],
        ),
      ),
    );
  }

  Widget _buildPopularDrinks() {
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
            SizedBox(
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
                  sections: showingPieChartSections(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                _buildPieChartIndicator(
                  color: const Color(0xFF5E35B1),
                  title: 'Milk Tea',
                  percentage: '42%',
                ),
                const SizedBox(height: 8),
                _buildPieChartIndicator(
                  color: const Color(0xFFFFA726),
                  title: 'Cold Brew Coffee',
                  percentage: '28%',
                ),
                const SizedBox(height: 8),
                _buildPieChartIndicator(
                  color: const Color(0xFF66BB6A),
                  title: 'Fruit Tea',
                  percentage: '16%',
                ),
                const SizedBox(height: 8),
                _buildPieChartIndicator(
                  color: const Color(0xFFEF5350),
                  title: 'Smoothies',
                  percentage: '14%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
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

  List<PieChartSectionData> showingPieChartSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xFF5E35B1),
            value: 42,
            title: '42%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xFFFFA726),
            value: 28,
            title: '28%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xFF66BB6A),
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xFFEF5350),
            value: 14,
            title: '14%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }

 Widget _buildCustomerSegments() {
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
            'Customer Age Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Color(0xff68737d),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = '<18';
                            break;
                          case 1:
                            text = '18-24';
                            break;
                          case 2:
                            text = '25-34';
                            break;
                          case 3:
                            text = '35-44';
                            break;
                          case 4:
                            text = '45+';
                            break;
                          default:
                            text = '';
                            break;
                        }
                        return SideTitleWidget(
                          meta: meta, // Pass meta here
                          space: 4,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return SideTitleWidget(
                          meta: meta, // Pass meta here
                          space: 4,
                          child: Text(
                            '${value.toInt()}%',
                            style: const TextStyle(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 12,
                        gradient: _buildBarGradient(),
                        width: 20,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 42,
                        gradient: _buildBarGradient(),
                        width: 20,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 30,
                        gradient: _buildBarGradient(),
                        width: 20,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 10,
                        gradient: _buildBarGradient(),
                        width: 20,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 6,
                        gradient: _buildBarGradient(),
                        width: 20,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}




  LinearGradient _buildBarGradient() {
    return const LinearGradient(
      colors: [
        Color(0xFF7F57C2),
        Color(0xFF5E35B1),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

 Widget _buildWeeklyPerformanceChart() {
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
            'Peak Hours Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                radarBorderData: const BorderSide(color: Colors.transparent),
                gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.2)),
                titlePositionPercentageOffset: 0.05,
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color(0xFF5E35B1).withOpacity(0.2),
                    borderColor: const Color(0xFF5E35B1),
                    entryRadius: 3,
                    dataEntries: const [
                      RadarEntry(value: 25), // 6-9 AM
                      RadarEntry(value: 48), // 9-12 PM
                      RadarEntry(value: 80), // 12-3 PM
                      RadarEntry(value: 65), // 3-6 PM
                      RadarEntry(value: 90), // 6-9 PM
                      RadarEntry(value: 40), // 9-12 AM
                    ],
                  ),
                ],
                titleTextStyle: const TextStyle(color: Colors.black, fontSize: 12),
                getTitle: (index, angle) {
                  const titles = [
                    '6-9 AM',
                    '9-12 PM',
                    '12-3 PM',
                    '3-6 PM',
                    '6-9 PM',
                    '9-12 AM',
                  ];
                  return index < titles.length
                      ? RadarChartTitle(text: titles[index], angle: 0)
                      : const RadarChartTitle(text: '');
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFA726).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFA726).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFFFA726),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Peak hours are between 6-9 PM. Consider adding more staff during these hours.',
                    style: TextStyle(color: Color(0xFFFFA726), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}