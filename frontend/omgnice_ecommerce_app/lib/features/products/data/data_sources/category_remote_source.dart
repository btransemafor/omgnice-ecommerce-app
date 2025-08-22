import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/caterogy.dart';
import 'package:dio/dio.dart';

abstract class CategoryRemoteSource {
  Future<List<CategoryModel>> getCategories();

}

class CategoryRemoteSourceImpl implements CategoryRemoteSource {
  final Dio dio = DioClient().client;
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(
        "/categories"
      );

      // check status code
      if (response.statusCode == 200 && response.data['data'] != null) {
         final List<dynamic> rawList = response.data["data"];
         return rawList.map((json) => CategoryModel.fromJson(json)).toList();
      }
      else {
        throw Exception('Invalid response format or status code');
      }

    } on DioException catch (e) {
      throw Exception(
        "Get categories failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }
}