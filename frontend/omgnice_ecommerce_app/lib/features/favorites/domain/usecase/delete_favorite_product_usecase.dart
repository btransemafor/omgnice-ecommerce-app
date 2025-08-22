import 'package:omgnice_ecommerce_app/features/favorites/domain/repositories/favorite_repository.dart';
class DeleteFavoriteProductUsecase {
  final FavoriteRepository favoriteRepository; 
  const DeleteFavoriteProductUsecase({required this.favoriteRepository}); 
  
  Future<bool> execute(int product_id) async {
    return await favoriteRepository.deleteFavoriteProduct(product_id); 
  }
}