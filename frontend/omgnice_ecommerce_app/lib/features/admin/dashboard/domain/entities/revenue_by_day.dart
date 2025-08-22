class RevenueByDay {
  final String date; 
  final int totalRevenue; 
  const RevenueByDay({
    required this.date, 
    required this.totalRevenue
  });

   factory RevenueByDay.fromJson(Map<String, dynamic> json) {
    return RevenueByDay(
      date: json['date'] ?? '',
      totalRevenue: (json["total_revenue"] as num?)?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'RevenueByDay(date: $date, totalRevenue: $totalRevenue)';
  }
}