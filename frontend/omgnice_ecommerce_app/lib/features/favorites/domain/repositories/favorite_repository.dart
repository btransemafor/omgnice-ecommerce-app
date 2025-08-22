import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_entity.dart';

abstract class FavoriteRepository {
  Future<List<ProductEntity>> getUserFavoriteProduct(); 
  Future<bool> addFavoriteProduct(int product_id); 
  Future<bool> deleteFavoriteProduct(int product_id); 
}