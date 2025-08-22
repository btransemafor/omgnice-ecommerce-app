import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_view_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/usecases/delete_itemcart_usecase.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/usecases/get_cart._usecasedart.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';

class CartProvider extends ChangeNotifier {
  final GetCartUsecase getCartUsecase;
  final DeleteItemcartUsecase deleteItemcartUsecase;
  final UpdateCartItemUsecase updateCartItemUsecase;
  final AddToCartUsease addToCartUsecase;

  CartProvider({
    required this.getCartUsecase,
    required this.deleteItemcartUsecase,
    required this.addToCartUsecase,
    required this.updateCartItemUsecase,
  });

  List<CartItemModel> _cart = [];
  int _quantityItemCart = 0;
  String _errorMessage = '';
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isSuccess = false;
  double _promotionDiscount = 0.0;
  double _originalTotal = 0.0;
  double _total = 0.0;

  PromotionEntity? _selectedPromotion;
  bool _isApplySuccess = false;

  // Public getters
  int get quantityItemCart => _quantityItemCart;
  List<CartItemModel> get cart => _cart;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  double get promotionDiscount => _promotionDiscount;
  double get originalTotal => _originalTotal;
  double get total => _total;
  PromotionEntity? get selectedPromotion => _selectedPromotion;
  bool get isApplySuccess => _isApplySuccess;

  void selectPromotion(PromotionEntity? promotion) {
    if (_selectedPromotion?.id != promotion?.id) {
      _selectedPromotion = promotion;
      print("____${promotion?.code} đã được chọn");
      notifyListeners();
    }
  }

  Future<void> applyPromotion(PromotionEntity promotion) async {
    print("DEBUG: --- Bắt đầu áp dụng voucher ---------------");
    _isApplySuccess = false;
    _selectedPromotion = promotion;
    await calculateTotal();
    double discountValue = 0.0;
    double specificProductTotal = 0;
    double specificCategoryTotal = 0;

    if (promotion.isActive == false) {
      _selectedPromotion = null;
      _promotionDiscount = 0.0;
      _isApplySuccess = false;
      print("Promotion không áp dụng do không còn hoạt động.");
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    if (promotion.startDate != null && now.isBefore(promotion.startDate!)) {
      _selectedPromotion = null;
      _promotionDiscount = 0.0;
      _isApplySuccess = false;
      print("Promotion không áp dụng do chưa bắt đầu.");
      notifyListeners();
      return;
    }

    if (promotion.endDate != null && now.isAfter(promotion.endDate!)) {
      _selectedPromotion = null;
      _promotionDiscount = 0.0;
      _isApplySuccess = false;
      print("Promotion không áp dụng do đã hết hạn.");
      notifyListeners();
      return;
    }

    if (promotion.usageLimit != null &&
        promotion.usedCount != null &&
        promotion.usedCount! >= promotion.usageLimit!) {
      _selectedPromotion = null;
      _promotionDiscount = 0.0;
      _isApplySuccess = false;
      print("Promotion không áp dụng do đã hết lượt sử dụng.");
      notifyListeners();
      return;
    }

    if (_total >= (promotion.minOrderValue ?? 0.0)) {
      final discount = promotion.discountValue ?? 0.0;

      if (promotion.appliesTo == 'ALL') {
        discountValue = promotion.discountType == "PERCENTAGE"
            ? (_total * discount) / 100
            : discount;
      } else if (promotion.appliesTo == 'PRODUCT') {
        for (final item in _cart) {
          if (item.productId == promotion.productId) {
            specificProductTotal += item.price ?? 0;
          }
        }
        discountValue = promotion.discountType == "PERCENTAGE"
            ? (specificProductTotal * discount) / 100
            : discount;
      } else if (promotion.appliesTo == 'CATEGORY') {
        for (final item in _cart) {
          if (item.category_id == promotion.categoryId) {
            specificCategoryTotal += item.price ?? 0;
          }
        }
        discountValue = promotion.discountType == "PERCENTAGE"
            ? (specificCategoryTotal * discount) / 100
            : discount;
      }

      final maxDiscount = promotion.maxDiscountValue ?? discountValue;
      discountValue = discountValue > maxDiscount ? maxDiscount : discountValue;
      _total -= discountValue;
      _total = _total < 0 ? 0 : _total;
      _promotionDiscount = discountValue;

      if (promotion.usedCount != null) {
        promotion.usedCount = promotion.usedCount! + 1;
      }

      _isApplySuccess = true;
      print('Sau khi áp dụng promotion: ${promotion.description}');
    } else {
      _selectedPromotion = null;
      _promotionDiscount = 0.0;
      _isApplySuccess = false;
      print("Promotion không áp dụng do không đạt giá trị tối thiểu.");
    }

    notifyListeners();
  }

  void resetSelectPromotion() {
    _selectedPromotion = null;
    _promotionDiscount = 0.0;
    _total = _originalTotal;
    notifyListeners();
  }

  Future<void> calculateTotal() async {
    _originalTotal = 0.0;
    _total = 0.0;
    for (final item in _cart) {
      final itemTotal = item.quantity! * item.discountPrice!;
      _originalTotal += itemTotal;
      _total += itemTotal;
    }
    notifyListeners();
  }

  Future<void> initCart() async {
    if (_selectedPromotion != null) {
      await applyPromotion(_selectedPromotion!);
    } else {
      await calculateTotal();
    }
    notifyListeners();
  }

  Future<void> init() async {
    try {
      await getCartUsecase.init();
      _isInitialized = true;
    } catch (e) {
      _errorMessage = 'Failed to initialize Hive Box: ${e.toString()}';
    }
  }

  Future<List<Map<String, dynamic>>> getVariantsByProductId(
      int productId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.11:8081/api/products/$productId/variants')); // Thay bằng URL API
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          return List<Map<String, dynamic>>.from(jsonData['data']['variants']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching variants: $e');
      return [];
    }
  }

  void updateCartItemLocally(
      int cartItemId, String variantName, double discountPrice, int variantId) {
    final index = _cart.indexWhere((item) => item.cartItemId == cartItemId);
    if (index != -1) {
      _cart[index] = _cart[index].copyWith(
        variantName: variantName,
        discountPrice: discountPrice,
        variantId: variantId,
      );
      calculateTotal();

      // Lưu vào Hive

      if (_cart[index].isInBox) {
        // Phải nằm trong box trước rồi nó mới save => nếu không nó không tự pop 
        // Mặc dù thật sự chả hiểu
        _cart[index].save();
      }

      // Tính lại tổng tiền và kiểm tra promotion
      calculateTotal();
      if (_selectedPromotion != null) {
        applyPromotion(_selectedPromotion!);
      }
      notifyListeners();
    }
  }

  void increaseQuantity(int cartItemId) async {
    final index = _cart.indexWhere((item) => item.cartItemId == cartItemId);
    if (index != -1) {
      final updatedItem = _cart[index].copyWith(
        quantity: _cart[index].quantity! + 1,
      );
      _cart[index] = updatedItem;
      calculateTotal();
      updatedItem.save(); // Lưu vào Hive
      await updateCartItemQuantity(cartItemId, updatedItem.quantity!);
      calculateTotal();
      if (selectedPromotion != null) {
        applyPromotion(selectedPromotion!);
      }
    }
  }

  void decreaseQuantity(int cartItemId) async {
    final index = _cart.indexWhere((item) => item.cartItemId == cartItemId);
    if (index != -1 && _cart[index].quantity! > 1) {
      final updatedItem = _cart[index].copyWith(
        quantity: _cart[index].quantity! - 1,
      );

      _cart[index] = updatedItem;
      calculateTotal();
      updatedItem.save(); // Lưu vào Hive
      notifyListeners();
      await updateCartItemQuantity(cartItemId, updatedItem.quantity!);
      if (selectedPromotion != null) {
        applyPromotion(selectedPromotion!);
      }
    }
  }

  void editNote(int cartItemId, String newNote) {
    final index = _cart.indexWhere((item) => item.cartItemId == cartItemId);
    if (index != -1) {
      final updatedItem = _cart[index].copyWith(note: newNote);
      _cart[index] = updatedItem;

      if (updatedItem.isInBox) {
        updatedItem.save(); // ✅ chỉ save khi item nằm trong box
      }
      //updatedItem.save(); // Lưu vào Hive
      notifyListeners();
    }
  }

  Future<bool> updateCartItem(
      Map<String, dynamic> updateData, int cartItemId) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();

    try {
      print(
          "Sending update request with data: ${jsonEncode(updateData)} for cartItemId: $cartItemId");
      bool result = await updateCartItemUsecase.execute(updateData, cartItemId);
      print("Result from server: $result");
      if (result) {
        _isSuccess = true;
        return true;
      } else {
        _errorMessage = 'Cập nhật giỏ hàng thất bại.';
        print(_errorMessage);
        return false;
      }
    } catch (error) {
      _errorMessage =
          'Đã xảy ra lỗi khi cập nhật giỏ hàng: ${error.toString()}';
      _isSuccess = false;
      print(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCartItemQuantity(int cartItemId, int newQuantity) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Giả sử usecase xử lý cập nhật quantity
    } catch (e) {
      _errorMessage = 'Error updating quantity: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCart() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final result = await getCartUsecase.execute();
      if (result != null && result.isNotEmpty) {
        _cart = result;
        _quantityItemCart = _cart.length;
        _isSuccess = true;
      } else {
        _cart = [];
        _quantityItemCart = 0;
        _errorMessage = 'Cart is empty.';
        _isSuccess = false;
      }
    } catch (e, stackTrace) {
      _cart = [];
      _quantityItemCart = 0;
      _errorMessage = 'Failed to load cart: ${e.toString()}';
      _isSuccess = false;
      debugPrint('Error: $e\nStackTrace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isDeleteSuccess = false;

  Future<void> deleteItem(int cartItemId) async {
    isDeleteSuccess = false;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      isDeleteSuccess = await deleteItemcartUsecase.call(cartItemId);
      if (isDeleteSuccess) {
        removeItemFromCart(cartItemId);
        calculateTotal();
      //  notifyListeners();
        if (selectedPromotion != null) {
          applyPromotion(selectedPromotion!);
        }
      } else {
        _errorMessage = 'Delete Item Cart Failed';
      }
    } catch (error) {
      _errorMessage = 'Delete Item Cart Failed: ${error.toString()}';
      isDeleteSuccess = false;
      debugPrint('Error deleting cart item: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeItemFromCart(int cartItemId) {
    _cart.removeWhere((item) => item.cartItemId == cartItemId);
    _quantityItemCart = _cart.length;
    notifyListeners();
  }

  Future<bool> clearCartFromHive() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (!_isInitialized) {
        await init();
      }
      _cart = [];
      _quantityItemCart = 0;
      debugPrint('Đã xóa toàn bộ cart trong Hive');
      return true;
    } catch (e) {
      _errorMessage = 'Failed to clear cart: ${e.toString()}';
      debugPrint('Lỗi khi xóa toàn bộ cart trong Hive: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearDeleteSuccessFlag() {
    isDeleteSuccess = false;
    notifyListeners();
  }

  bool isAddSuccess = false;

  Future<bool> addToCart(CartItemViewModel cartItemViewModel) async {
    _isLoading = true;
    _errorMessage = '';
    isAddSuccess = false;
    notifyListeners();
    try {
      final cartItemModel = cartItemViewModel.cartItemModel;
      isAddSuccess = await addToCartUsecase.call(
        cartItemModel.variantName,
        cartItemModel.quantity,
        cartItemModel.note,
        cartItemModel.productId,
      );
      if (isAddSuccess) {
        await getCart();
        print("Thêm sản phẩm vào giỏ hàng thành công.");
        return true;
      } else {
        _errorMessage = 'Thêm sản phẩm vào giỏ hàng thất bại.';
        return false;
      }
    } catch (error) {
      _errorMessage = "Lỗi khi thêm vào giỏ hàng: ${error.toString()}";
      isAddSuccess = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
