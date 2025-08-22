import 'package:omgnice_ecommerce_app/features/cart/data/sources/cart_local_data_source.dart';
import 'package:omgnice_ecommerce_app/features/cart/data/sources/cart_remote_source_impl.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/repositories/cart_repositoy.dart';

class CartRepositoryImpl extends CartRepository {
  final CartRemoteSource cartRemoteSource;
  final CartLocalDataSource cartLocalDataSource;

  CartRepositoryImpl({
    required this.cartRemoteSource,
    required this.cartLocalDataSource,
  });

  @override
  Future<void> init() async {
    await cartLocalDataSource.init();
  }

  @override
  Future<List<CartItemModel>> getCart() async {
    try {
      // 🔥 Gọi API lấy dữ liệu giỏ hàng
      final apiCart = await cartRemoteSource.getCart();

      // 🔥 Lưu dữ liệu vào Hive (Local Storage) để cache
      ///await cartLocalDataSource.saveCart(apiCart);

      return apiCart;
    }
    catch(error) {
      throw Exception(error.toString());
    }

    // catch (e) {
      // 🔥 Nếu lỗi, lấy dữ liệu từ Local Storage (Hive)
      /*
      try {
        return cartLocalDataSource.getCartItems();
      } catch (localError) {
        throw Exception("Không thể tải dữ liệu từ Local Storage: $localError");
      }
    }
       */
  }

  @override
  Future<void> saveCart(List<CartItemModel> items) async {
    await cartLocalDataSource.saveCart(items);
  }

  @override
  Future<void> clearCart() async {
    try {
      // Có thể thêm API call để xóa toàn bộ giỏ hàng trên server nếu có
      // await cartRemoteSource.clearCart();

      // Xóa dữ liệu local
      await cartLocalDataSource.clearCart();
    } catch (e) {
      print('❌ Lỗi khi xóa toàn bộ giỏ hàng: $e');
      throw Exception("Không thể xóa giỏ hàng: $e");
    }
  }

  @override
  Future<bool> deleteCartItem(int cartItemId) async {
    try {
      final result = await cartRemoteSource.deleteCartItem(cartItemId);
      if (result) {
        print('✅ Xóa sản phẩm thành công với ID: $cartItemId');
        try {
         // await cartLocalDataSource.deleteCartItem(cartItemId);
          print('✅ Đã đồng bộ xóa sản phẩm trong local storage với ID: $cartItemId');
        } catch (localError) {
          print('⚠️ Lỗi khi xóa local storage (API đã xóa thành công): $localError');
          // Không throw exception ở đây vì API đã xóa thành công
        }

        return true;
      } else {
        print('❌ Xóa sản phẩm thất bại với ID: $cartItemId');
        return false;
      }
    } catch (e) {
      print('❌ Lỗi khi xóa sản phẩm từ API: $e');

      // Trong trường hợp lỗi mạng, có thể xem xét xóa local để đồng bộ offline
      // Bạn có thể bỏ comment phần code dưới đây nếu muốn cho phép xóa offline
      /*
      try {
        // Offline deletion - xóa trong local storage ngay cả khi API lỗi
        if (await cartLocalDataSource.deleteCartItem(cartItemId)) {
          print('⚠️ API lỗi nhưng đã xóa local: $cartItemId');
          return true; // Có thể trả về true hoặc false tùy vào yêu cầu của ứng dụng
        }
      } catch (localError) {
        print('❌ Không thể xóa sản phẩm từ local: $localError');
      }
      */

      return false;
    }
  }

  // Thêm phương thức mới - Kiểm tra item có tồn tại trong local không
  bool hasCartItemLocal(int cartItemId) {
    try {
      return cartLocalDataSource.hasCartItem(cartItemId);
    } catch (e) {
      print('❌ Lỗi khi kiểm tra item trong local: $e');
      return false;
    }
  }

  // Lấy số lượng item trong cart từ local
  int getCartCountLocal() {
    try {
      return cartLocalDataSource.getCartCount();
    } catch (e) {
      print('❌ Lỗi khi đếm số item trong local: $e');
      return 0;
    }
  }

  // Lấy một item cụ thể từ local
  CartItemModel? getCartItemLocal(int cartItemId) {
    try {
      return cartLocalDataSource.getCartItem(cartItemId);
    } catch (e) {
      print('❌ Lỗi khi lấy item từ local storage: $e');
      return null;
    }
  }
  @override
  Future<bool> addCartItem(String? variant_name, int ? quantity, String? note, int? product_id) async {
    return await cartRemoteSource.addCartItem(variant_name, quantity, note, product_id,);
  }

  @override
  Future<bool> updateCartItem(Map<String, dynamic> updateData, int cartItemId) async {
    return  await cartRemoteSource.updateCartItem(updateData, cartItemId);
  }
}