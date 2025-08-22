import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';

class PromotionModel extends PromotionEntity {
  PromotionModel({
    int? id,
    String? code,
    String? title,
    String? description,
    String? discountType,
    double? discountValue,
    double? maxDiscountValue,
    double? minOrderValue,
    String? appliesTo,
    int? productId,
    int? categoryId,
    DateTime? startDate, 
    DateTime? endDate,
    int? usageLimit,
    int? usedCount,
    bool? isActive,
    bool? isExclusive,
  }) : super(
          id: id,
          code: code,
          title: title,
          description: description,
          discountType: discountType,
          discountValue: discountValue,
          maxDiscountValue: maxDiscountValue,
          minOrderValue: minOrderValue,
          appliesTo: appliesTo,
          productId: productId,
          categoryId: categoryId,
          startDate: startDate,
          endDate: endDate,
          usageLimit: usageLimit,
          usedCount: usedCount,
          isActive: isActive,
          isExclusive: isExclusive,
        );

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      description: json['description'],
      discountType: json['discount_type'],
      discountValue: (json['discount_value'] as num?)?.toDouble(),
      maxDiscountValue: (json['max_discount_value'] as num?)?.toDouble(),
      minOrderValue: (json['min_order_value'] as num?)?.toDouble(),
      appliesTo: json['applies_to'],
      productId: json['product_id'],
      categoryId: json['category_id'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      usageLimit: json['usage_limit'],
      usedCount: json['used_count'],
      isActive: json['is_active'],
      isExclusive: json['is_exclusive'] ?? false, // Default to false if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'max_discount_value': maxDiscountValue,
      'min_order_value': minOrderValue,
      'applies_to': appliesTo,
      'product_id': productId,
      'category_id': categoryId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'usage_limit': usageLimit,
      'used_count': usedCount,
      'is_active': isActive,
    };
  }

  @override
  String toString() {
    return 'PromotionModel(id: $id, code: $code, title: $title, description: $description, discountValue: $discountValue)';
  }
}
