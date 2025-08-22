// lib/data/models/product_detail_model.dart

import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_detail_entity.dart';

class ProductDetailModel extends ProductDetailEntity {
  ProductDetailModel({
    int? id,
    String? name,
    String? description,
    int? soldQuantity,
    int? stockQuantity,
    String? imageUrl,
    double? discountPercent,
    int? categoryId,
    double? ratingStar,
    List<ProductVariantEntity>? variants,
  }) : super(
            id: id,
            name: name,
            description: description,
            soldQuantity: soldQuantity,
            stockQuantity: stockQuantity,
            imageUrl: imageUrl,
            discountPercent: discountPercent,
            categoryId: categoryId,
            ratingStar: ratingStar,
            variants: variants);

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      soldQuantity: json['soldQuantity'],
      stockQuantity: json['stockQuantity'],
      imageUrl: json['imageUrl'],
      discountPercent: json['discount_percent']?.toDouble(),
      categoryId: json['category_id'],
      ratingStar: json['rating_star']?.toDouble(),
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((item) => ProductVariantModel.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'soldQuantity': soldQuantity,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl,
      'discount_percent': discountPercent,
      'category_id': categoryId,
      'rating_star': ratingStar,
      'variants': variants
              ?.map((variant) => (variant as ProductVariantModel).toJson())
              .toList() ??
          [],
    };
  }

  // Tạo một bản sao với một số thuộc tính thay đổi
  ProductDetailModel copyWith({
    int? id,
    String? name,
    String? description,
    int? soldQuantity,
    int? stockQuantity,
    String? imageUrl,
    double? discountPercent,
    int? categoryId,
    double? ratingStar,
    List<ProductVariantEntity>? variants,
  }) {
    return ProductDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      soldQuantity: soldQuantity ?? this.soldQuantity,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      discountPercent: discountPercent ?? this.discountPercent,
      categoryId: categoryId ?? this.categoryId,
      ratingStar: ratingStar ?? this.ratingStar,
      variants: variants ?? this.variants,
    );
  }
}

class ProductVariantModel extends ProductVariantEntity {
  ProductVariantModel(
      {int? id, String? nameVariant, double? price, double? discountPrice})
      : super(
            id: id,
            nameVariant: nameVariant,
            price: price,
            discountPrice: discountPrice);

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'],
      nameVariant: json['name_variant'],
      price: json['price'].toDouble(),
      discountPrice: json['discount_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_variant': nameVariant,
      'price': price,
      'discount_price': discountPrice,
    };
  }

  // Tạo một bản sao với một số thuộc tính thay đổi
  ProductVariantModel copyWith({
    int? id,
    String? nameVariant,
    double? price,
    double? discountPrice,
  }) {
    return ProductVariantModel(
      id: id ?? this.id,
      nameVariant: nameVariant ?? this.nameVariant,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
    );
  }
}
