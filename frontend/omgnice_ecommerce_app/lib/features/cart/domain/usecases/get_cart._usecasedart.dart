import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/repositories/cart_repositoy.dart';

class GetCartUsecase {
  final CartRepository cartRepository;

  GetCartUsecase({required this.cartRepository});

  /// 🔥 Thêm hàm init để đảm bảo Hive Box được khởi tạo trước khi gọi execute()
  Future<void> init() async {
    await cartRepository.init();
  }

  Future<List<CartItemModel>> execute() async {
    return await cartRepository.getCart();
  }
}
