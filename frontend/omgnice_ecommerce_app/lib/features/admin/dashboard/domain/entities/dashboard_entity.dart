class DashboardEntity {
  final int totalOrders;
  final int processingOrders;
  final int completedOrders;
  final int totalCustomers;
  final int totalRevenue;
  final int orderValueTotal;

  DashboardEntity({
    required this.totalOrders,
    required this.processingOrders,
    required this.completedOrders,
    required this.totalCustomers,
    required this.totalRevenue,
    required this.orderValueTotal,
  });

   @override
  String toString() {
    return 'DashboardEntity(totalOrders: $totalOrders, processingOrders: $processingOrders, completedOrders: $completedOrders, totalCustomers: $totalCustomers, totalRevenue: $totalRevenue)';
  }
}