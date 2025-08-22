import 'dart:convert';

import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/products/data/model/product_detail_model.dart';
import 'package:dio/dio.dart';

import '../../domains/entities/product.dart';

abstract class ProductRemoteSource {
  Future<List<ProductCardModel>> getProductsByCategory(int categoryId);
  Future<ProductDetailModel> getProductDetailById(int id);
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

class ProductRemoteSourceImpl implements ProductRemoteSource {
  final Dio dio = DioClient().client;

  @override
  Future<List<ProductCardModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await dio.get(
        "/products/by-category/$categoryId",
      );

      final List<dynamic> rawList = response.data["data"];
      print(rawList);
      return rawList.map((json) => ProductCardModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        "Get Product by Category ID failed: ${e.response?.data["message"] ?? e.message}",
      );
    }
  }

  @override
  Future<List<ProductCardModel>> searchProduct({
    String? query,
    String? category,
    String? variant,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int page = 1,
    int limit = 10,
  }) async {
    final Map<String, dynamic> params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (query != null && query.isNotEmpty) params['query'] = query;
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (variant != null && variant.isNotEmpty) params['variant'] = variant;
    if (minPrice != null) params['minPrice'] = minPrice.toString();
    if (maxPrice != null) params['maxPrice'] = maxPrice.toString();
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;

    try {
      final response = await dio.get(
        "/products/search",
        queryParameters: params, 
      );


      print("Số sản phẩm đã tìm được sau khi search: , ${response.data['data']}"); 

      final List<dynamic> rawList = response.data["data"];
      return rawList.map((json) => ProductCardModel.fromJson(json)).toList();
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? e.message;
      throw Exception("Search product failed: $message");
    }
  }

  @override
  Future<ProductDetailModel> getProductDetailById(int id) async {
    try {
      print('🔍 [DEBUG] Bắt đầu gọi API lấy chi tiết sản phẩm với id = $id');

      final response = await dio.get("/products/$id");

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response data: ${response.data}');

      if (response.statusCode == 200 && response.data["success"] == true) {
        final json = response.data["data"];

        if (json == null) {
          throw Exception("[ERROR] Không có trường 'data' trong phản hồi.");
        }

        final productDetail = ProductDetailModel.fromJson(json);
        print(
            '[DEBUG] Parse thành công ProductDetailModel: ${productDetail.name}');
        return productDetail;
      } else {
        throw Exception('[ERROR] API trả về lỗi hoặc response không hợp lệ');
      }
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? e.message;
      print('[ERROR] DioException: $message');
      throw Exception("Get product detail failed: $message");
    } catch (e) {
      print('[ERROR] Exception: $e');
      throw Exception("Lỗi không xác định: $e");
    }
  }
}
