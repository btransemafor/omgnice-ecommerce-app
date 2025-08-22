import 'package:omgnice_ecommerce_app/features/favorites/data/source/remotes/favorite_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_entity.dart';


class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteSource favoriteRemoteSource; 
  const FavoriteRepositoryImpl({required this.favoriteRemoteSource}); 

  @override
  Future<List<ProductEntity>> getUserFavoriteProduct() async {
    return await favoriteRemoteSource.getFavoriteProduct();  
  }

  @override
  Future<bool> addFavoriteProduct(int product_id) async {
    return await favoriteRemoteSource.addFavoriteProduct(product_id); 
  }

  @override
  Future<bool> deleteFavoriteProduct(int product_id) async {
    return await favoriteRemoteSource.deleteFavoriteProduct(product_id); 
  }
}

