class OrderByMonth {
  final String month; // Format: YYYY-MM
  final int orderCount;

  OrderByMonth({
    required this.month,
    required this.orderCount,
  });

  factory OrderByMonth.fromJson(Map<String, dynamic> json) {
    return OrderByMonth(
      month: json['month'] ?? '',
      orderCount: (json['order_count'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'OrderByMonth(month: $month, orderCount: $orderCount)';
  }
}