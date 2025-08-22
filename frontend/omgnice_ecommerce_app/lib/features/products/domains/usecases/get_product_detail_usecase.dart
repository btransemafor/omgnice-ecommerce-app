import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_detail_entity.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/repositories/product_repository.dart';

class GetProductDetailUsecase {
  final ProductRepository productRepository;
  const GetProductDetailUsecase({ required this.productRepository});

  Future<ProductDetailEntity> execute(int id) async {
    return await productRepository.getProductDetailById(id);
  }
}