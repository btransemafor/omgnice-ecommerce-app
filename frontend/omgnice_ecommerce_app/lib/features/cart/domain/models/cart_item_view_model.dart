import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
class CartItemViewModel {
  final CartItemModel cartItemModel;
  final String? productName; // Thêm tên sản phẩm nếu cần
  final String? imageUrl;
  //final int priceUnit; // Thêm giá sản phẩm nếu cần

  CartItemViewModel({
    required this.cartItemModel,
     this.imageUrl,
     this.productName,
    //required this.priceUnit,
  });

  // Tính tổng tiền
 // int get totalPrice => cartItemModel.quantity * priceUnit;

  // Format tiền dễ đọc
 // String get formattedTotalPrice => '${totalPrice.toStringAsFixed(0)} đ';


}


