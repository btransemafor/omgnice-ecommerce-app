// lib/domain/entities/product_detail_entity.dart

class ProductDetailEntity {
  final int? id;
  final String? name;
  final String? description;
  final int? soldQuantity;
  final int? stockQuantity;
  final String? imageUrl;
  final double? discountPercent;
  final int? categoryId;
  final double? ratingStar;
  final List<ProductVariantEntity>? variants;

  const ProductDetailEntity({
    this.id,
    this.name,
    this.description,
    this.stockQuantity,
    this.imageUrl,
    this.discountPercent,
    this.soldQuantity,
    this.categoryId,
    this.ratingStar,
    this.variants,
  });
}

class ProductVariantEntity {
  final int? id;
  final String? nameVariant;
  final double? price;
  final double? discountPrice;

  const ProductVariantEntity({
    this.id,
    this.nameVariant,
    this.price,
    this.discountPrice,
  });
}
