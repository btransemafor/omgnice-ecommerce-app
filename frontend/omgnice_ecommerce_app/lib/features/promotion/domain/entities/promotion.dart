class PromotionEntity {
  final int? id;
  final String? code;
  final String? title;
  final String? description;

  final String? discountType; // PERCENTAGE or FIXED
  final double? discountValue;
  final double? maxDiscountValue;

  final double? minOrderValue;

  final String? appliesTo; // ALL, PRODUCT, CATEGORY
  final int? productId;
  final int? categoryId;

  final DateTime? startDate;
  final DateTime? endDate;

  final int? usageLimit;
  int? usedCount;
  final bool? isActive;

  final bool? isExclusive;

  PromotionEntity({
    this.id,
    this.code,
    this.title,
    this.description,
    this.discountType,
    this.discountValue,
    this.maxDiscountValue,
    this.minOrderValue,
    this.appliesTo,
    this.productId,
    this.categoryId,
    this.startDate,
    this.endDate,
    this.usageLimit,
    this.usedCount,
    this.isActive,
    this.isExclusive
  });

  PromotionEntity copyWith({
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
}) {
  return PromotionEntity(
    id: id ?? this.id,
    code: code ?? this.code,
    title: title ?? this.title,
    description: description ?? this.description,
    discountType: discountType ?? this.discountType,
    discountValue: discountValue ?? this.discountValue,
    maxDiscountValue: maxDiscountValue ?? this.maxDiscountValue,
    minOrderValue: minOrderValue ?? this.minOrderValue,
    appliesTo: appliesTo ?? this.appliesTo,
    productId: productId ?? this.productId,
    categoryId: categoryId ?? this.categoryId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    usageLimit: usageLimit ?? this.usageLimit,
    usedCount: usedCount ?? this.usedCount,
    isActive: isActive ?? this.isActive,
  );
}
@override
String toString() {
  return 'PromotionEntity(id: $id, code: $code, title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, maxDiscountValue: $maxDiscountValue, minOrderValue: $minOrderValue, appliesTo: $appliesTo, productId: $productId, categoryId: $categoryId, startDate: $startDate, endDate: $endDate, usageLimit: $usageLimit, usedCount: $usedCount, isActive: $isActive)';
}

}
