import 'package:flutter/material.dart';
import 'dart:io';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/usecase/create_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/usecase/delete_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/usecase/fetch_list_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/usecase/update_product_usecase.dart';

class AdminProductProvider extends ChangeNotifier {
  final CreateProductUsecase createProductUsecase;
  final FetchListProductUsecase fetchListProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  Product? p;
  bool isSuccess = false;

  List<Product> _listProduct = [];
  List<Product> get listProduct => _listProduct;

  List<Product> _filteredProducts = [];
  List<Product> get filterProducts => _filteredProducts;

  AdminProductProvider({
    required this.createProductUsecase,
    required this.fetchListProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
  });

  Future<void> addProduct(Product product, File imageProduct) async {
    try {
      debugPrint('Bắt đầu thêm sản phẩm, isLoading = true');
      _setLoading(true);
      notifyListeners();
      p = await createProductUsecase.createProduct(product, imageProduct);
      if (p != null) {
        isSuccess = true;
      }
      _setError(null);
      debugPrint('Hoàn tất thêm sản phẩm');
    } catch (e) {
      debugPrint('Lỗi: $e');
      _setError('$e');
    } finally {
      debugPrint('Kết thúc, isLoading = false');
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> fetchListProduct() async {
    try {
      _setLoading(true);
      _listProduct = await fetchListProductUsecase.execute();
      _setError(null);
      if (_listProduct.isNotEmpty) {
        debugPrint('Danh sach san pham: ${_listProduct.length}');
        debugPrint('HEHE: ${_listProduct[4].variants}');
      } else {
        debugPrint('List Empty');
      }
    } catch (error) {
      _setError('$error');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  List<Product> filterProduct(int selectedCategory) {
    _filteredProducts = _listProduct
        .where((product) => product.category_id == selectedCategory)
        .map((product) => product.copyWith()) // Sao chép để giữ nguyên dữ liệu
        .toList();
    debugPrint('Filtered products variants: ${_filteredProducts.map((p) => p.variants).toList()}');
    notifyListeners();
    return _filteredProducts;
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = [];
    } else {
      query = query.toLowerCase();
      _filteredProducts = _listProduct
          .where((product) =>
              product.name.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query))
          .map((product) => product.copyWith()) // Sao chép để giữ nguyên dữ liệu
          .toList();
    }
    debugPrint('Searched products variants: ${_filteredProducts.map((p) => p.variants).toList()}');
    notifyListeners();
    return _filteredProducts;
  }

  List<Product> searchAndFilterProducts(String query, int? categoryId) {
    query = query.toLowerCase();
    if (categoryId != null) {
      _filteredProducts = _listProduct
          .where((product) =>
              (product.name.toLowerCase().contains(query) ||
                  product.description.toLowerCase().contains(query)) &&
              product.category_id == categoryId)
          .map((product) => product.copyWith()) // Sao chép để giữ nguyên dữ liệu
          .toList();
    } else {
      _filteredProducts = _listProduct
          .where((product) =>
              product.name.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query))
          .map((product) => product.copyWith()) // Sao chép để giữ nguyên dữ liệu
          .toList();
    }
    debugPrint('Search and filter variants: ${_filteredProducts.map((p) => p.variants).toList()}');
    notifyListeners();
    return _filteredProducts;
  }

  void resetFilter() {
    _filteredProducts = [];
    notifyListeners();
  }

  void resetSearch() {
    _filteredProducts = [];
    notifyListeners();
  }

  Future<void> updateProduct(String product_id, Map<String, dynamic> product, File? updateImage) async {
    try {
      _setLoading(true);
      debugPrint('Updating product ID: $product_id with changes: $product');
      debugPrint("${product['variants']}");
      
      await updateProductUsecase.call(
          productId: product_id, updatedImage: updateImage, changedFields: product);
      _setError(null);
    } catch (e) {
      debugPrint('Update product error: $e');
      _setError('Failed to update product: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      isSuccess = false;
      _setLoading(true);
      isSuccess = await deleteProductUsecase.execute(id);
      if (isSuccess) {
        await fetchListProductUsecase.execute();
        _setError(null);
      } else {
        _setError('Không thể xóa sản phẩm thành công');
      }
    } catch (e) {
      isSuccess = false;
      _setError('Failed to delete product: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _setError(String? message) {
    _errorMessage = message;
  }

  void setSuccess(bool value) {
    isSuccess = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearNew() {
    isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }
}
