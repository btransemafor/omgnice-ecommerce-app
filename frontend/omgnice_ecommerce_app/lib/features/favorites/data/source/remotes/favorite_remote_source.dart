// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/products/data/model/product_model.dart';

abstract class FavoriteRemoteSource {
  Future<List<ProductModel>> getFavoriteProduct();
  Future<bool> addFavoriteProduct(int product_id);
  Future<bool> deleteFavoriteProduct(int product_id);
}

class FavoriteRemoteSourceImpl implements FavoriteRemoteSource {
  final Dio dio = DioClient().client;

  @override
  Future<List<ProductModel>> getFavoriteProduct() async {
    try {
      print("Đang gọi tới server ...........");
      final response = await dio.get('/users/favorites/');
      print(response.statusCode);
      final data = response.data['data'];
      //final favorite_products = data['favorite_products'] as List; // Rất dễ crash
      //final favorite_pproducts = (data['favorite_products'] as List?) ?? [];
      final products = (data['favorite_products'] as List?) ?? [];
      return products.map((item) => ProductModel.fromJson(item)).toList();
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  @override
  Future<bool> addFavoriteProduct(int product_id) async {
    try {
      print("Đang gọi tới server ...........");
      final response = await dio.post(
        '/users/favorites/$product_id',
        options: Options(
          validateStatus: (status) {
            return status != null && status < 500; // Cho phép 409, chặn 500+
          },
        ),
      );
      print(response.statusCode);
      final data = response.data;
      if (response.statusCode == 201 && data['success'] == true) {
        print('Added Favorite Product Successfully');
        return true;
      } else if (response.statusCode == 409) {
        print("Sản phẩm đã tồn tại");
        return false;
      } else {
        return false;
      }
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  /// *---------------DELETE PRODUCT ----------------*
  @override
  Future<bool> deleteFavoriteProduct(int product_id) async {
    print('Đang gọi tới server để thực hiện chức năng xóa');
    try {
      final response = await dio.delete('/users/favorites/$product_id');
      print(response.statusCode);
      final data = response.data;
      if (response.statusCode == 200 && data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }
}
