import 'package:hive/hive.dart';
import '../../domain/models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _boxName = 'cartBox';
  late Box<CartItemModel> _cartBox;

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _cartBox = await Hive.openBox<CartItemModel>(_boxName);
    } else {
      _cartBox = Hive.box<CartItemModel>(_boxName);
    }
  }

  Future<void> saveCart(List<CartItemModel> items) async {
    await _cartBox.clear(); // Xóa dữ liệu cũ trước khi lưu mới
    for (var item in items) {
      await _cartBox.put(item.cartItemId, item);
    }
  }

  List<CartItemModel> getCartItems() {
    if (!_cartBox.isOpen) {
      throw Exception("Hive Box '$_boxName' chưa được khởi tạo! Hãy gọi init() trước.");
    }
    return _cartBox.values.toList();
  }

  // Xóa một item cụ thể theo cartItemId
  Future<bool> deleteCartItem(int cartItemId) async {
    if (!_cartBox.isOpen) {
      throw Exception("Hive Box '$_boxName' chưa được khởi tạo! Hãy gọi init() trước.");
    }

    // Kiểm tra xem item có tồn tại không
    if (_cartBox.containsKey(cartItemId)) {
      await _cartBox.delete(cartItemId);
      return true;
    } else {
      print('⚠️ Không tìm thấy item với ID: $cartItemId trong Hive Box');
      return false;
    }
  }

  // Xóa toàn bộ cart
  Future<void> clearCart() async {
    if (!_cartBox.isOpen) {
      throw Exception("Hive Box '$_boxName' chưa được khởi tạo! Hãy gọi init() trước.");
    }
    await _cartBox.clear();
    print('🗑️ Đã xóa toàn bộ cart trong Hive Box');
  }

  // Kiểm tra xem một item có tồn tại trong box không
  bool hasCartItem(int cartItemId) {
    if (!_cartBox.isOpen) {
      throw Exception("Hive Box '$_boxName' chưa được khởi tạo! Hãy gọi init() trước.");
    }
    return _cartBox.containsKey(cartItemId);
  }

  // Lấy một item cụ thể
  CartItemModel? getCartItem(int cartItemId) {
    if (!_cartBox.isOpen) {
      throw Exception("Hive Box '$_boxName' chưa được khởi tạo! Hãy gọi init() trước.");
    }
    return _cartBox.get(cartItemId);
  }

  // Đếm số lượng items trong cart
  int getCartCount() {
    if (!_cartBox.isOpen) {
      throw Exception("Hive Box '$_boxName' chưa được khởi tạo! Hãy gọi init() trước.");
    }
    return _cartBox.length;
  }
}