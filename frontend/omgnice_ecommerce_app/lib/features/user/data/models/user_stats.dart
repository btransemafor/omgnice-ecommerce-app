import 'package:omgnice_ecommerce_app/features/user/domain/entities/userStats.dart';

class UserStatsModel extends Userstats {
  const UserStatsModel({
    required super.totalQuantityOrder,
    required super.totalSpending,
    required super.totalCoupon,
    required super.completedOrders,
    required super.cancelledOrders,
    required super.averageSpending,
    required super.cancelRate,
    required super.lastOrderDate,
  });

  // Convert Json to model
  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
         totalQuantityOrder: (json['totalQuantityOrder'] as num?)?.toInt() ?? 0,
    totalSpending: (json['totalSpending'] as num?)?.toInt() ?? 0,
    totalCoupon: (json['totalCoupon'] as num?)?.toInt() ?? 0,
    completedOrders: (json['completedOrders'] as num?)?.toInt() ?? 0,
    cancelledOrders: (json['cancelledOrders'] as num?)?.toInt() ?? 0,
    averageSpending: (json['averageSpending'] as num?)?.toInt() ?? 0,
    cancelRate: (json['cancelRate'] as num?)?.toDouble() ?? 0,
    lastOrderDate: json['lastOrderDate'] != null
        ? (DateTime.tryParse(json['lastOrderDate']) ?? DateTime(1970, 1, 1))
        : DateTime(1970, 1, 1)
    ); 
  }
}
