import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required int id,
    required String userId,
    required String orderLineId,
    required int ratingStar,
    required String comment,
    required DateTime reviewDate,
    required int productId,
    required int variantId,
    required String userName,
    String? userAvatar,
  }) : super(
          id: id,
          userId: userId,
          orderLineId: orderLineId,
          ratingStar: ratingStar,
          comment: comment,
          reviewDate: reviewDate,
          productId: productId,
          variantId: variantId,
          userName: userName,
          userAvatar: userAvatar,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userId: json['user_id'],
      orderLineId: json['order_line_id'],
      ratingStar: json['rating_star'],
      comment: json['comment'],
      reviewDate: DateTime.parse(json['review_date']),
      productId: json['product_id'],
      variantId: json['variant_id'],
      userName: json['user']?['name'] ?? 'Unknown',
      userAvatar: json['user'] != null && json['user']['avatar'] != null
    ? json['user']['avatar']
    : "https://res.cloudinary.com/dehehzz2t/image/upload/v1745651286/download_e4ryfq.png",

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_line_id': orderLineId,
      'rating_star': ratingStar,
      'comment': comment,
      'review_date': reviewDate.toIso8601String(),
      'product_id': productId,
      'variant_id': variantId,
      'user': {
        'name': userName,
        'avatar': userAvatar,
      }
    };
  }
}
