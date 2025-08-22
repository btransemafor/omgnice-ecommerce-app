import 'package:omgnice_ecommerce_app/features/cart/domain/repositories/cart_repositoy.dart';

class UpdateCartItemUsecase {
  final CartRepository cartRepository;
  const UpdateCartItemUsecase({required this.cartRepository});

  Future<bool> execute(Map<String, dynamic> updateData, int cartItemId) async  {
    return await cartRepository.updateCartItem(updateData, cartItemId);
  }
}