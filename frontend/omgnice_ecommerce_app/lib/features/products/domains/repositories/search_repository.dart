import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';

abstract class SearchRepository {
  Future<List<ProductCardModel>?> searchProduct(String query);
}