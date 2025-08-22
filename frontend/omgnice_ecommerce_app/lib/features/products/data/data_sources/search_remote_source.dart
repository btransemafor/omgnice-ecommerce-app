import 'package:dio/dio.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';

abstract class SearchRemoteSource {
  Future<List<ProductCardModel>?> searchProduct(String query);

}

class SearchRemoteSourceImpl implements SearchRemoteSource {
  final Dio dio;
  SearchRemoteSourceImpl({required this.dio});
  static const _baseUrl = 'http://10.0.2.2:8081/api';
  static const _jsonHeader  = {"Content-Type": "application/json"} ;
  @override
  Future<List<ProductCardModel>?> searchProduct(String query) async {
    try {
      final response = await dio.get(
        "$_baseUrl/products/search?query=${query}",
        options: Options(headers: _jsonHeader),
      );

      // check status code
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> rawList = response.data["data"];
        return rawList.map((json) => ProductCardModel.fromJson(json)).toList();
      }
      else {
        throw Exception('Invalid response format or status code');
      }

    } on DioException catch (e) {
      throw Exception(
        "Search Product By Key failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }
}



