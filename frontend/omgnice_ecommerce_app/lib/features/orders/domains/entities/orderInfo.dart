class OrderInfo {
  final String userId;
  final String addressId;
  final String shippingMethodId;
  final double shippingFee;
  final double discountAmount;
  final int? promotionId;
  final double orderTotal;
  final String note;
  final String paymentMethod;
  final String? deliveryTimeSlot; 

  OrderInfo({
    required this.userId,
    required this.addressId,
    required this.shippingMethodId,
    required this.shippingFee,
    required this.discountAmount,
    this.promotionId,
    required this.orderTotal,
    required this.note,
    required this.paymentMethod,
    this.deliveryTimeSlot 
  });

  // Convert from JSON
  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      userId: json['user_id'],
      addressId: json['address_id'],
      shippingMethodId: json['shipping_method_id'],
      shippingFee: json['shipping_fee'].toDouble(),
      discountAmount: json['discountAmount'].toDouble(),
      promotionId: json['promotion_id'],
      orderTotal: json['orderTotal'].toDouble(),
      note: json['note'],
      paymentMethod: json['payment_method'],
      deliveryTimeSlot: json['delivery_time_slot']
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'address_id': addressId,
      'shipping_method_id': shippingMethodId,
      'shipping_fee': shippingFee,
      'discountAmount': discountAmount,
      'promotion_id': promotionId,
      'orderTotal': orderTotal,
      'note': note,
      'payment_method': paymentMethod,
      'delivery_time_slot' : deliveryTimeSlot 
    };
  }
}
