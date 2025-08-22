import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/repositories/product_repository.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/repositories/search_repository.dart';

class SearchProductUsecase{
   final ProductRepository productRepository;
   const SearchProductUsecase({required this.productRepository});

Future<List<ProductCardModel>> searchProduct({
    String? query,
    String? category,
    String? variant,
    double? minPrice,
    double? maxPrice,
    String? sort, // price_asc | price_desc
    int page = 1,
    int limit = 10,
  }) async {
      return productRepository.searchProduct(query: query, category: category, variant: variant, minPrice: minPrice, maxPrice: maxPrice, sort: sort, page: page, limit: limit); 
  }
}