import 'package:hive/hive.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final int? cartItemId;

  @HiveField(1)
  final String? nameProduct;

  @HiveField(2)
  final int? productId;

  @HiveField(3)
  final int? variantId;


  @HiveField(4)
  final String? imageProduct;

  @HiveField(5)
  final String? variantName;

  @HiveField(6)
  final num? price;
  @HiveField(7)
  final num? discountPrice; 

  @HiveField(8)
  int? quantity; 

  @HiveField(9)
  late final String? note;

  @HiveField(10)
  late final int? category_id;

  CartItemModel({
    this.cartItemId,
    this.nameProduct,
    this.productId,
    this.variantId,
    this.imageProduct,
    this.variantName,
    this.price,
    this.discountPrice,
    this.quantity,
    this.note,
    this.category_id
  });

  /// Parse từ JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cartitem_id'] as int?,
      nameProduct: json['name_product'] as String?,
      productId: json['product_id'] as int?,
      variantId: json['variant_id'] as int?,
      imageProduct: json['image_product'] as String?,
      variantName: json['name_variant'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
      note: json['note'] as String?,
      category_id: json['category_id'] as int?
    );
  }

  /// Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'cartitem_id': cartItemId,
      'name_product': nameProduct,
      'product_id': productId,
      'variant_id': variantId,
      'image_product': imageProduct,
      'name_variant': variantName,
      'price': price,
      'discount_price': discountPrice,
      'quantity': quantity,
      'note': note,
      "category_id": category_id,
    };
  }

  ///  Hàm copyWith để dễ dàng sao chép và cập nhật đối tượng
  CartItemModel copyWith({
    int? cartItemId,
    String? nameProduct,
    int? productId,
    int? variantId,
    String? imageProduct,
    String? variantName,
    num? price,
    num? discountPrice,
    int? quantity,
    String? note,
    int? category_id 
  }) {
    return CartItemModel(
      cartItemId: cartItemId ?? this.cartItemId,
      nameProduct: nameProduct ?? this.nameProduct,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      imageProduct: imageProduct ?? this.imageProduct,
      variantName: variantName ?? this.variantName,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      category_id: category_id ?? this.category_id
    );
  }
}
