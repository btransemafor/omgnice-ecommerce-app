import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    int? productId,
    int? variantId,
    int? quantity,
    required double price,
    String? note,
    String? productName,
    String? variantName,
    String? thumbnail,
    String? order_line_id ,
    required bool? is_review 
  }) : super(

          productId: productId,
          variantId: variantId,
          quantity: quantity,
          price: price,
          note: note,
          productName: productName,
          variantName: variantName,
          thumbnail: thumbnail,
          order_line_id: order_line_id, 
          is_review: is_review
        );

  // Phương thức chuyển Entity thành Model
  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      is_review: entity.is_review,
      productId: entity.productId,
      variantId: entity.variantId,
      quantity: entity.quantity,
      price: entity.price,
      note: entity.note,
      productName: entity.productName,
      variantName: entity.variantName,
      thumbnail: entity.thumbnail,
      order_line_id: entity.order_line_id
    );
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      is_review: json['isReview'] ?? false,
      productId: json['productId'] is int ? json['productId'] : int.tryParse(json['productId'].toString()) ?? 0,
      variantId: json['variantId'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      note: json['note'],
      productName: json['productName'],
      variantName: json['variantName'],
      thumbnail: json['thumbnail'],
      order_line_id: json['order_line_id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variantId': variantId,
      'quantity': quantity,
      'price': price,
      'note': note,
    };
  }
}
