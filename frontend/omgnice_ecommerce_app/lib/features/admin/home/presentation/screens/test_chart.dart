import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily App Usage Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}h',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Text(
                      days[value.toInt()],
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.black12)),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 6,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 1), // Monday: 1 hour
                  FlSpot(1, 2), // Tuesday: 2 hours
                  FlSpot(2, 1.5), // Wednesday: 1.5 hours
                  FlSpot(3, 3), // Thursday: 3 hours
                  FlSpot(4, 2.5), // Friday: 2.5 hours
                  FlSpot(5, 4), // Saturday: 4 hours
                  FlSpot(6, 3), // Sunday: 3 hours
                ],
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}