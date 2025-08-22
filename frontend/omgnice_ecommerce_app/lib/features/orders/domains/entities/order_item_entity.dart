class OrderItemEntity {
  final int? productId;
  final int? variantId;
  final int? quantity;
  final double price;
  final String? note;
  final String? order_line_id; 

  // Dùng để hiển thị
  final String? productName;
  final String? variantName;
  final String? thumbnail;
  final bool? is_review; 

  const OrderItemEntity({
    this.productId,
    this.variantId,
    this.quantity,
    required this.price,
    this.note,
    this.productName,
    this.variantName,
    this.thumbnail,
    this.order_line_id, 
    this.is_review
  });

   OrderItemEntity copyWith({
    int? productId,
    int? variantId,
    int? quantity,
    double? price,
    String? note,
    String? order_line_id,
    String? productName,
    String? variantName,
    String? thumbnail,
    bool? is_review,
  }) {
    return OrderItemEntity(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      note: note ?? this.note,
      order_line_id: order_line_id ?? this.order_line_id,
      productName: productName ?? this.productName,
      variantName: variantName ?? this.variantName,
      thumbnail: thumbnail ?? this.thumbnail,
      is_review: is_review ?? this.is_review,
    );
  }
}
