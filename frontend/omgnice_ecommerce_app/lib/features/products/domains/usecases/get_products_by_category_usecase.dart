import 'package:omgnice_ecommerce_app/features/products/domains/repositories/product_repository.dart';
import '../entities/product.dart';
class GetProductsByCategoryUsecase {
  final ProductRepository productRepository;

  const GetProductsByCategoryUsecase({required this.productRepository});

  Future<List<ProductCardModel>> getProductsByCategory(int categoryId) async{

    return await productRepository.getProductsByCategory(categoryId);
  }
}