import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';

abstract class CartRepository {
  Future<void> init(); // Khởi tạo Hive Box
  Future<List<CartItemModel>> getCart();
  Future<void> saveCart(List<CartItemModel> items);
  Future<void> clearCart();
  Future<bool> deleteCartItem(int cartItemId);


  // Add to cart
  Future<bool> addCartItem(String? variant_name, int? quantity, String? note,
      int? product_id) ;
  Future<bool> updateCartItem(Map<String, dynamic> updateData, int cartItemId);
}




