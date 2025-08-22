import 'package:flutter/widgets.dart';
import 'package:omgnice_ecommerce_app/features/favorites/domain/usecase/add_favorite_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/favorites/domain/usecase/delete_favorite_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/favorites/domain/usecase/get_favorite_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_entity.dart';

class FavoriteProvider extends ChangeNotifier {
  final GetFavoriteProductUsecase getFavoriteProductUsecase;
  final AddFavoriteProductUsecase addFavoriteProductUsecase;
  final DeleteFavoriteProductUsecase deleteFavoriteProductUsecase;

  FavoriteProvider(
      {required this.addFavoriteProductUsecase,
      required this.getFavoriteProductUsecase,
      required this.deleteFavoriteProductUsecase});

  List<ProductEntity> _userFavorite = [];
  List<ProductEntity> get userFavorite => _userFavorite;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  String _message = '';
  String get message => _message;

  Future<void> addFavoriteProduct(int productId) async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      final success = await addFavoriteProductUsecase.execute(productId);
      _isSuccess = success;

      _message =
          success ? "Đã thêm vào yêu thích" : "Sản phẩm đã có trong yêu thích";
    } catch (e) {
      _isSuccess = false;
      _message = 'Lỗi server';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFavoriteProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final favorites = await getFavoriteProductUsecase.execute();
      _userFavorite = favorites;
      _isSuccess = true;
    } catch (e) {
      _message = 'Lỗi khi tải danh sách sản phẩm yêu thích';
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFavoriteProducts(int product_id) async {
    _isSuccess = true;
    _isLoading = true;
    notifyListeners();
    try {
      _isSuccess = await deleteFavoriteProductUsecase.execute(product_id);
      if (_isSuccess) {
        // ignore: avoid_print
        print('Đã xóa sản phẩm thành công');
        await fetchFavoriteProducts();
      }
    } catch (error) {
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(int productId) {
    return _userFavorite.any((product) => product.id == productId);
  }
}
