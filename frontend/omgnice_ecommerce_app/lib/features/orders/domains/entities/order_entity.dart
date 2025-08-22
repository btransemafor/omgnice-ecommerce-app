
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';

import 'order_item_entity.dart';

class OrderEntity {
  final String? id;
  final String? userId;
  final AddressEntity address; 
  final String shippingMethodId;
  // final String shipping
 
  final double orderTotal;
  final int? promotionId;
  final String? shipping; 
  final String? notes;
  final double shippingFee;
  final double discountAmount;
  final String? orderStatus;
  final DateTime? orderDate;
  final DateTime? deliveryCompletedAt;
  final DateTime? updateAt ; 
  final String? order_line_id ; 
  final String? delivery_time_slot; 
  // Payment 
  final String paymentMethod;
  final DateTime? paidAt; 
  final bool paymentStatus; 
  final List<OrderItemEntity>? items; 

  // review chua ???? 
  //final bool isReview;


  OrderEntity({
    this.order_line_id,
    this.id,
    this.userId,
    required this.address,
    required this.shippingMethodId,
    this.shipping, 
    required this.paymentMethod,
    required this.orderTotal,
    this.delivery_time_slot, 
    this.promotionId,
    this.notes,
    required this.shippingFee,
    required this.discountAmount,
    this.orderStatus,
    this.orderDate,
    this.deliveryCompletedAt,
    this.paidAt, 
    required this.paymentStatus, 
    this.items,
    this.updateAt
  });


    OrderEntity copyWith({
    String? id,
    String? userId,
    AddressEntity? address,
    String? shippingMethodId,
    double? orderTotal,
    int? promotionId,
    String? shipping,
    String? notes,
    double? shippingFee,
    double? discountAmount,
    String? orderStatus,
    DateTime? orderDate,
    DateTime? deliveryCompletedAt,
    DateTime? updateAt,
    String? order_line_id,
    String? delivery_time_slot,
    String? paymentMethod,
    DateTime? paidAt,
    bool? paymentStatus,
    List<OrderItemEntity>? items,
    bool? isReview,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      shippingMethodId: shippingMethodId ?? this.shippingMethodId,
      shipping: shipping ?? this.shipping,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderTotal: orderTotal ?? this.orderTotal,
      delivery_time_slot: delivery_time_slot ?? this.delivery_time_slot,
      promotionId: promotionId ?? this.promotionId,
      notes: notes ?? this.notes,
      shippingFee: shippingFee ?? this.shippingFee,
      discountAmount: discountAmount ?? this.discountAmount,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      deliveryCompletedAt: deliveryCompletedAt ?? this.deliveryCompletedAt,
      paidAt: paidAt ?? this.paidAt,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      items: items ?? this.items,
      updateAt: updateAt ?? this.updateAt,
      order_line_id: order_line_id ?? this.order_line_id,
    );
  }
}


  
