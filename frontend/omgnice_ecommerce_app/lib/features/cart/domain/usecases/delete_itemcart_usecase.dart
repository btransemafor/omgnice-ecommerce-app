import 'package:hive/hive.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/repositories/cart_repositoy.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/cart/data/sources/cart_local_data_source.dart';
class DeleteItemcartUsecase {
  final CartRepository cartRepository ;
  const DeleteItemcartUsecase({required this.cartRepository});

  Future<bool> call(int cartItemId) async {

    return  await cartRepository.deleteCartItem(cartItemId);
  }
}