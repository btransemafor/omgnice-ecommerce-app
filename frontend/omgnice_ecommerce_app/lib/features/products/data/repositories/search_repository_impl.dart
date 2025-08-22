import 'package:omgnice_ecommerce_app/features/products/domains/repositories/search_repository.dart';
import '../data_sources/search_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteSource searchRemoteSource;

  SearchRepositoryImpl({required this.searchRemoteSource});
  @override
  Future<List<ProductCardModel>?> searchProduct(String query) async {
    return await searchRemoteSource.searchProduct(query);
  }
}


