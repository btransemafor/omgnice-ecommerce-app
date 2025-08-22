class ReviewEntity {
  final int id;
  final String userId;
  final String orderLineId;
  final int ratingStar;
  final String comment;
  final DateTime reviewDate;
  final int productId;
  final int variantId;
  final String userName;
  final String? userAvatar;

  ReviewEntity({
    required this.id,
    required this.userId,
    required this.orderLineId,
    required this.ratingStar,
    required this.comment,
    required this.reviewDate,
    required this.productId,
    required this.variantId,
    required this.userName,
    this.userAvatar,
  });
}
