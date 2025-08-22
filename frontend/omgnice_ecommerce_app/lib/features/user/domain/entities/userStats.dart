class Userstats {
  final int totalQuantityOrder; 
  final int totalSpending;
  final int totalCoupon;
  final int completedOrders;
  final int cancelledOrders;
  final int averageSpending;
  final double cancelRate;
  final DateTime lastOrderDate;

  const Userstats({
    required this.totalQuantityOrder, 
    required this.totalSpending, 
    required this.totalCoupon, 
    required this.completedOrders, 
    required this.cancelledOrders, 
    required this.averageSpending, 
    required this.cancelRate, 
    required this.lastOrderDate,
    
  }); 

}