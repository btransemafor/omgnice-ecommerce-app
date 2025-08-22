class ProductCardModel {
  final int? id;
  final String name;
  final int soldQuantity;
  final String imageUrl;
  final int categoryId;
  final int discountPercent;
  final bool? isHidden;
  final bool? is_premium;
  final double? starReview; // Thêm ? để cho phép null
  final double priceS;

  ProductCardModel(
      {this.id,
      required this.name,
      required this.soldQuantity,
      required this.imageUrl,
      required this.categoryId,
      required this.discountPercent,
      this.isHidden,
      this.is_premium,
      this.starReview,
      required this.priceS});

  factory ProductCardModel.fromJson(Map<String, dynamic> json) {
    return ProductCardModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      soldQuantity: json['soldQuantity'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      categoryId:
          json['categoryId'] ?? 0, // Sửa từ category_id thành categoryId
      discountPercent: json['discountPercent'] ?? 0,
      isHidden: json['is_hidden'] ?? false,
      is_premium: json['is_premium'] ?? false,
      starReview: json['averageRating'] != null
          ? double.tryParse(json['averageRating'].toString())
          : null,
      priceS: (json['variant_s_price'] as num).toDouble(),
    );
  }
}
