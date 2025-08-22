import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';

class ShippingMethodModel extends ShippingMethodEntity {
  const ShippingMethodModel({
    required String id,
    required String description,
    required String name,
    required double price,
    required double discountPrice,
  }) : super(
          id: id,
          description: description,
          name: name,
          price: price,
          discountPrice: discountPrice,
        );

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    return ShippingMethodModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      name: json['name_shipping_method'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: (json["discount_price"] ?? 0).toDouble(),
    );
  }
}
