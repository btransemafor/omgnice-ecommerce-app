import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';

class ProductModel extends Product {
  ProductModel({
    String? id,
    required String name,
    required String imageUrl,
    required String description,
    required bool isHidden,
    required int soldQuantity,
    required int category_id,
    required int discountPercent,
    required Map<String, double> variants,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          description: description,
          isHidden: isHidden,
          soldQuantity: soldQuantity,
          category_id: category_id,
          discountPercent: discountPercent.toInt(),
          variants: variants
        );
factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id']?.toString(),
    name: json['name_product'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    description: json['description'] ?? '',
    isHidden: json['isHidden'] ?? false,
    soldQuantity: json['soldQuantity'] ?? 0,
    category_id: (json['category_id'] as num?)?.toInt() ?? 0,
    discountPercent: (json['discount_percent'] as num?)?.toInt() ?? 0,
    variants: json['variants'] != null
        ? Map<String, double>.from(json['variants'])
        : {},
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_product': name,
      'description': description,
      'imageUrl': imageUrl,
      'category_id': category_id,
      'discount_percent': discountPercent,
      'isHidden': isHidden,
      'variants': variants,
    };
  }
}
