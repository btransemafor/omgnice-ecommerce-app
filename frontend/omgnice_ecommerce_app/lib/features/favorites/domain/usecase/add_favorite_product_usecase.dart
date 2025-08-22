import 'package:omgnice_ecommerce_app/features/favorites/domain/repositories/favorite_repository.dart';

class AddFavoriteProductUsecase {
  final FavoriteRepository favoriteRepository; 
  const AddFavoriteProductUsecase({required this.favoriteRepository}); 

  Future<bool> execute(int product_id) async {
    return await favoriteRepository.addFavoriteProduct(product_id); 
  }
}