import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  BannerModel({
    int? id, 
    required String title,
    required String imageUrl,
    required String actionType,
    required String actionValue,
    required DateTime startTime,
    required DateTime endTime,
    int? productId,
    int? categoryId,
    bool isLuckyWheelBanner = false,    // Thêm trường này nếu có trong entity
    DateTime? createdAt,                // Nếu entity có, thêm param này
  }) : super(
          id:id ,
          title: title,
          imageUrl: imageUrl,
          actionType: actionType,
          actionValue: actionValue,
          startTime: startTime,
          endTime: endTime,
          productId: productId,
          categoryId: categoryId,
          isLuckyWheelBanner: isLuckyWheelBanner,
          createdAt: createdAt ?? DateTime.now(),
        );

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id:json['id'],
      categoryId: json['category_id'] as int?,
      productId: json['product_id'] as int?,
      title: json['title'] ?? '',
      imageUrl: (json['imageUrl'] as String?)?.trim().isNotEmpty == true
          ? json['imageUrl']
          : 'https://res.cloudinary.com/dehehzz2t/image/upload/v1744298721/0338498306_xp0g6j.png',
      actionType: json['actionType'] ?? '',
      actionValue: json['actionValue'] ?? '',
      startTime: DateTime.tryParse(json['startTime'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] ?? '') ??
          DateTime.now().add(const Duration(days: 7)),
      isLuckyWheelBanner: json['isLuckyWheelBanner'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'actionType': actionType,
      'actionValue': actionValue,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'product_id': productId,
      'category_id': categoryId,
      'isLuckyWheelBanner': isLuckyWheelBanner,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BannerModel.fromEntity(BannerEntity entity) {
  return BannerModel(
    id: entity.id,
    title: entity.title,
    imageUrl: entity.imageUrl,
    actionType: entity.actionType,
    actionValue: entity.actionValue!,
    startTime: entity.startTime,
    endTime: entity.endTime,
    productId: entity.productId,
    categoryId: entity.categoryId,
    isLuckyWheelBanner: entity.isLuckyWheelBanner,
    createdAt: entity.createdAt,
  );
}

}
