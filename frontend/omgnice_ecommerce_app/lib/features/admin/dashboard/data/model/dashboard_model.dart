import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  DashboardModel({
    required super.totalOrders,
    required super.processingOrders,
    required super.completedOrders,
    required super.totalCustomers,
    required super.totalRevenue,
    required super.orderValueTotal,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalOrders: json['totalOrders'] ?? 0,
      processingOrders: json['processingOrders'] ?? 0,
      completedOrders: json['completedOrders'] ?? 0,
      totalCustomers: json['totalCustomers'] ?? 0,
      totalRevenue: json['totalRevenue'] ?? 0,
      orderValueTotal: json['orderValueTotal'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'processingOrders': processingOrders,
      'completedOrders': completedOrders,
      'totalCustomers': totalCustomers,
      'totalRevenue': totalRevenue,
      'orderValueTotal': orderValueTotal,
    };
  }

  @override
  String toString() {
    return 'DashboardModel(totalOrders: $totalOrders, processingOrders: $processingOrders, completedOrders: $completedOrders, totalCustomers: $totalCustomers, totalRevenue: $totalRevenue)';
  }
}