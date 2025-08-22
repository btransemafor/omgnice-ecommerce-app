import 'package:omgnice_ecommerce_app/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_entity.dart';

class GetFavoriteProductUsecase {
  final FavoriteRepository favoriteRepository; 
  const GetFavoriteProductUsecase({required this.favoriteRepository}); 
  Future<List<ProductEntity>> execute() async {
    return await favoriteRepository.getUserFavoriteProduct(); 
  }
}