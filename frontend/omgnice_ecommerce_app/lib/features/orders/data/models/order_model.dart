import 'package:flutter/material.dart';

import '../../domains/entities/order_entity.dart';
import '../../../../../features/location/data/models/address_model.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    String? id,
    String? userId,
    required AddressModel address,
    required String shippingMethodId,
    String? shipping,
    required String paymentMethod,
    required double orderTotal,
    int? promotionId,
    String? notes,
    required double shippingFee,
    required double discountAmount,
    String? orderStatus,
    DateTime? orderDate,
    DateTime? deliveryCompletedAt,
    DateTime? updateAt,
    //String? order_line_id,
    DateTime? paidAt, 
    required bool paymentStatus, 
    List<OrderItemModel>? items,
  
  }) : super(
          id: id,
          paymentStatus: paymentStatus,
          paidAt: paidAt,
          userId: userId,
          address: address,
          shipping: shipping,
          shippingMethodId: shippingMethodId,
          paymentMethod: paymentMethod,
          orderTotal: orderTotal,
          promotionId: promotionId,
          notes: notes,
          shippingFee: shippingFee,
          discountAmount: discountAmount,
          orderStatus: orderStatus,
          orderDate: orderDate,
          updateAt: updateAt,
          deliveryCompletedAt: deliveryCompletedAt,
          items: items,

          //  order_line_id: order_line_id
        );
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Parse address
    final addressData = json['address'] as Map<String, dynamic>?;

    // Parse items list an toàn
    final List<OrderItemModel> orderItems = (json['items'] as List<dynamic>?)
            ?.map((item) {
              try {
                return OrderItemModel(
                  is_review: item['isReview'] ?? false,
                    productId: item['productId'] ?? 0,
                    variantId: item['variantId'] ?? 0,
                    quantity: item['quantity'] ?? 0,
                    price: parseToDouble(item['price']),
                    note: item['note'] ?? '',
                    productName: item['productName'] ?? '',
                    variantName: item['variantName'] ?? '',
                    thumbnail: item['thumbnail'] ?? '',
                    order_line_id: item['order_line_id'] ?? '', 
                    
                  
                    //order_line_id:
                    );
              } catch (e) {
                debugPrint('❌ Lỗi khi parse item: $e\n$item');
                return null;
              }
            })
            .whereType<OrderItemModel>()
            .toList() ??
        [];

    return OrderModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      address: addressData != null
          ? AddressModel.fromJson(addressData)
          : throw Exception("❌ Address không tồn tại hoặc sai định dạng"),
      shippingMethodId:
          json['shipping_method_id'] ?? json['shippingMethodId'] ?? '',
      shipping: json['shippingMethod'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      orderTotal: parseToDouble(json['orderTotal']),
      promotionId: json['promotion_id'] is int ? json['promotion_id'] : null,
      notes: json['notes'],
      shippingFee: parseToDouble(json['shipping_fee']),
      discountAmount: parseToDouble(json['promotionDiscount']),
      orderStatus: json['orderStatus'] ?? '',
      orderDate: json['orderDate'] != null
          ? DateTime.tryParse(json['orderDate'])
          : null,
      deliveryCompletedAt: json['deliveredAt'] != null
          ? DateTime.tryParse(json['deliveredAt'])
          : null,
      updateAt: json['updateAt'],
      paidAt: json['paidAt'] != null ? DateTime.tryParse(json['paidAt']): null ,
      paymentStatus: json['paymentStatus'],
      items: orderItems,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'address_id': address.id, //  Trích ID từ AddressModel để gửi lên server
      'shipping_method_id': shippingMethodId,
      'payment_method': paymentMethod,
      'orderTotal': orderTotal,
      'promotion_id': promotionId,
      'notes': notes,
      'shipping_fee': shippingFee,
      'discount_amount': discountAmount,
      'items': items?.map((item) {
        return OrderItemModel(
          is_review: item.is_review ?? false,
          productId: item.productId,
          variantId: item.variantId,
          quantity: item.quantity ?? 0,
          price: item.price,
          note: item.note,
          productName: item.productName,
          variantName: item.variantName,
          thumbnail: item.thumbnail,
          order_line_id: item.order_line_id
        ).toJson();
      }).toList(),
    };
  }

  // Convert Entity into Model
  factory OrderModel.fromEntity(OrderEntity entity) {
    // Check if address is null or needs conversion
    AddressModel addressModel;
    if (entity.address is AddressModel) {
      addressModel = entity.address as AddressModel;
    } else {
      // You need to create an appropriate conversion here
      // For example: addressModel = AddressModel.fromEntity(entity.address);
      throw Exception("Address conversion not implemented");
    }

    return OrderModel(
     // isReview: entity.isReview,
      paymentStatus: entity.paymentStatus,
      id: entity.id,
      userId: entity.userId,
      address: addressModel,
      shippingMethodId: entity.shippingMethodId,
      paymentMethod: entity.paymentMethod,
      orderTotal: entity.orderTotal,
      promotionId: entity.promotionId,
      notes: entity.notes,
      shippingFee: entity.shippingFee,
      discountAmount: entity.discountAmount,
      orderStatus: entity.orderStatus,
      orderDate: entity.orderDate,
      deliveryCompletedAt: entity.deliveryCompletedAt,
      // Safely convert items
      items: entity.items
          ?.map((item) =>
              item is OrderItemModel ? item : OrderItemModel.fromEntity(item))
          .toList(),
    );
  }
}

double parseToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
