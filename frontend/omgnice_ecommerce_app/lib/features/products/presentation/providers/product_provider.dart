// ProductProvider.dart
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/products/data/model/product_detail_model.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_detail_entity.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/usecases/get_product_detail_usecase.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/usecases/get_products_by_category_usecase.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/usecases/search_product_usecase.dart';

class ProductProvider extends ChangeNotifier {
  final GetProductsByCategoryUsecase getProductsByCategoryUC;
  final GetProductDetailUsecase getProductDetailUsecase;
  final SearchProductUsecase searchProductUsecase;

  ProductProvider({
    required this.getProductsByCategoryUC,
    required this.getProductDetailUsecase,
    required this.searchProductUsecase,
  });

  bool _isLoading = false;
  List<ProductCardModel> _products = [];
  ProductDetailEntity? _productDetail;

  // Dung cho cac san pham cho recommend
  List<ProductCardModel> _recommendProducts = [];
  List<ProductCardModel> get recommendProducts => _recommendProducts;

  bool get isLoading => _isLoading;
  List<ProductCardModel> get products => _products;
  ProductDetailEntity? get productDetail => _productDetail;

  String? _selectedSize;
  String? get selectedSize => _selectedSize;

  double _selectedPrice = 0.0;
  double get selectedPrice => _selectedPrice;

  int _quantity = 1;
  double _total = 0.0;
  String? _noteForOrder = '';

  double get total => _total;
  int get quantity => _quantity;
  String? get noteForOrder => _noteForOrder;

  void saveNote(String? note) {
    _noteForOrder = note;
    notifyListeners();
  }

  void resetNote() {
    _noteForOrder = '';
    notifyListeners();
  }

  void increaseQuantity() {
    _quantity += 1;
    calculateTotalPrice();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      calculateTotalPrice();
    }
  }

  void calculateTotalPrice() {
    final price = getPrice(_selectedSize ?? '') ?? 0.0;
    _total = _quantity * price;
    notifyListeners();
  }

  void chooseSize(String sizeName) {
    _selectedSize = sizeName;
    _selectedPrice = getPrice(sizeName) ?? 0.0;
    calculateTotalPrice();
    notifyListeners();
  }

  void resetSelectedSize() {
    _selectedSize = null;
    _selectedPrice = 0.0;
    _total = 0.0;
    _quantity = 1;
    notifyListeners();
  }

  Future<void> getProductsByCategory(int categoryId) async {
    if (_isLoading) return;

    _products = [];
    _isLoading = true;
    notifyListeners();

    try {
      final result =
          await getProductsByCategoryUC.getProductsByCategory(categoryId);
      _products = result;
      print("Số sản phẩm được tải: ${_products.length}");
    } catch (e) {
      print("Lỗi khi tải sản phẩm: $e");
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductDetailById(int id) async {
    _isLoading = true;
    _productDetail = null;
    notifyListeners();

    try {
      print("Bắt đầu getProductDetailById với id: $id");
      final result = await getProductDetailUsecase.execute(id);
      _productDetail = result;

      if (result.variants != null && result.variants!.isNotEmpty) {
        final hasSizeS =
            result.variants!.any((variant) => variant.nameVariant == "S");
        if (hasSizeS) {
          _selectedSize = "S";
        } else {
          _selectedSize = result.variants![0].nameVariant;
        }

        _selectedPrice = getPrice(_selectedSize ?? '') ?? 0.0;
        _quantity = 1;
        _noteForOrder = '';
        calculateTotalPrice();
      }

      print("Lấy chi tiết sản phẩm thành công: ${_productDetail?.name}");
    } catch (e) {
      print("Lỗi khi tải chi tiết sản phẩm: $e");
      _productDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProduct({
    String? query,
    String? category,
    String? variant,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int page = 1,
    int limit = 10,
  }) async {
    _isLoading = true;
    _products = [];
    notifyListeners();

    try {
      final results = await searchProductUsecase.searchProduct(
        query: query,
        category: category,
        variant: variant,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sort: sort,
        page: page,
        limit: limit,
      );

      _products = results;
      print("Search trả về: ${_products.length} sản phẩm");
      print("Test thu san so 1${_products[1].name} omgnice");
    } catch (e) {
      print("Lỗi khi search sản phẩm: $e");
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get San pham co id 10

  Future<void> getRecommendedProducts() async {
    _recommendProducts = [];
    _isLoading = true;
    notifyListeners();

    try {
      final result = await getProductsByCategoryUC.getProductsByCategory(10);
      _recommendProducts = result;
      print(
          "Số sản phẩm có caterogy id = 10 được tải: ${_recommendProducts.length}");
          for(final i in _recommendProducts) {
               print('${i.name}  ${i.starReview}');
          }
     
    } catch (e) {
      print("Lỗi khi tải sản phẩm: $e");
      _recommendProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Get gia khuyen mai nhe
  double? getPrice(String nameVariant) {
    final variants = productDetail?.variants ?? [];
    try {
      final match = variants.firstWhere(
        (v) => v.nameVariant == nameVariant,
        orElse: () => ProductVariantModel(nameVariant: nameVariant, price: 0.0),
      );

      return match.discountPrice;
    } catch (e) {
      print("Lỗi khi lấy giá: $e");
      return 0.0;
    }
  }



  void resetProducts() {
    _products = []; 
    notifyListeners(); 
  }
}
