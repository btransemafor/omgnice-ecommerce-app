import 'package:omgnice_ecommerce_app/features/cart/domain/repositories/cart_repositoy.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';

class AddToCartUsease {
  final CartRepository cartRepository ;


  const AddToCartUsease({required this.cartRepository});

  Future<bool> call(String? variant_name, int? quantity, String? note,
      int? product_id,) async {
    return await cartRepository.addCartItem(variant_name, quantity, note, product_id,);

  }
}
