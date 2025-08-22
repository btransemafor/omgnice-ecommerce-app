class VariantModel {
  final int variantId;
  final String variantName;
  final double price;
  final double discountPrice;

  VariantModel({
    required this.variantId,
    required this.variantName,
    required this.price,
    required this.discountPrice,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      variantId: json['variant_id'] as int,
      variantName: json['variant_name'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num).toDouble(),
    );
  }
}