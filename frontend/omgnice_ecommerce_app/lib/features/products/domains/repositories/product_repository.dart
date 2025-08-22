
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_detail_entity.dart';


abstract class ProductRepository {
  Future<List<ProductCardModel>> getProductsByCategory(int categoryId);
  Future<ProductDetailEntity> getProductDetailById(int id);
  Future<List<ProductCardModel>> searchProduct({
    String? query,
    String? category,
    String? variant,
    double? minPrice,
    double? maxPrice,
    String? sort, // price_asc | price_desc
    int page = 1,
    int limit = 10,
  }); 
}