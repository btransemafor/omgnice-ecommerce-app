//import 'package:omgnice_ecommerce_app/features/products/data/data_sources/product_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/products/data/model/product_detail_model.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/repositories/product_repository.dart';
import '../data_sources/product_remote_source.dart';
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteSource  productRemoteSource;
  ProductRepositoryImpl({required this.productRemoteSource});

  @override
  Future<List<ProductCardModel>> getProductsByCategory(int categoryId) async {
    return await productRemoteSource.getProductsByCategory(categoryId);
  }

  @override
  Future<ProductDetailModel> getProductDetailById(int id) async {
    return await productRemoteSource.getProductDetailById(id);
  }

  @override
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
    return await productRemoteSource.searchProduct(query: query, category: category, variant: variant, minPrice: minPrice, maxPrice: maxPrice, sort: sort, page: page, limit: limit); 
  }

}