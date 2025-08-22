// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/data/models/product_model.dart'
    as adminProductModel;
import 'package:path/path.dart';

abstract class AdminProductRemoteSource {
  Future<adminProductModel.ProductModel> createProduct(
      adminProductModel.ProductModel p, File imageProduct);
  Future<void> updateProduct(String product_id,
      Map<String, dynamic> changedFields, File? imageProduct);

  Future<List<adminProductModel.ProductModel>> getProducts();
  Future<bool> deleteProduct(String id);
}

class AdminProductRemoteImpl implements AdminProductRemoteSource {
  final Dio dio;

  AdminProductRemoteImpl({required this.dio});

  @override
  Future<adminProductModel.ProductModel> createProduct(
      adminProductModel.ProductModel product, File imageProduct) async {
    debugPrint('=== Bắt đầu tạo sản phẩm qua API ===');
    debugPrint('Input Product:');
    debugPrint('  ID: ${product.id}');
    debugPrint('  Name: ${product.name}');
    debugPrint('  Description: ${product.description}');
    debugPrint('  Variants: ${product.variants}');
    debugPrint('  Category ID: ${product.category_id}');
    debugPrint('  Discount Percent: ${product.discountPercent}');
    debugPrint('  Is Hidden: ${product.isHidden}');
    debugPrint('  Image Path: ${imageProduct.path}');

    try {
      // Chuẩn bị FormData
      print('Chuẩn bị FormData...');
      final formData = FormData.fromMap({
        'name': product.name,
        'description': product.description,
        'category_id': product.category_id,
        'discount_percent': product.discountPercent.toString(),
        'isHidden': product.isHidden.toString(),
        'variants': product.variants.toString(),
        'soldQuantity': product.soldQuantity ?? 0,
        'image': await MultipartFile.fromFile(
          imageProduct.path,
          filename: basename(imageProduct.path),
        ),
      });

      print('FormData fields:');
      formData.fields.forEach((entry) {
        print('  ${entry.key}: ${entry.value}');
      });
      print('FormData files:');
      formData.files.forEach((entry) {
        print('  ${entry.key}: ${entry.value.filename}');
      });

      print('📤 Gửi POST request tới /products/');
      final response = await dio.post(
        '/products/',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      // Xử lý phản hồi
      if (response.statusCode == 201 && response.data['success'] == true) {
        print('Tạo sản phẩm thành công!');
        return adminProductModel.ProductModel.fromJson(response.data);
      } else {
        // Dự phòng: status không phải 201 hoặc response sai cấu trúc
        throw Exception('Tạo sản phẩm thất bại: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == 409) {
        final msg = 'Sản phẩm đã tồn tại';
        throw Exception(msg);
      } else if (status == 400) {
        final msg = data['message'] ?? 'Yêu cầu không hợp lệ';
        throw Exception('[400] $msg');
      } else if (status == 500) {
        throw Exception('[500] Lỗi máy chủ. Vui lòng thử lại sau.');
      } else {
        throw Exception(
            '[${status ?? 'Unknown'}] ${data?['message'] ?? e.message}');
      }
    } catch (e) {
      print('Lỗi không xác định khi tạo sản phẩm: $e');
      throw Exception('Đã có lỗi xảy ra: $e');
    } finally {
      print('=== Kết thúc tạo sản phẩm qua API ===');
    }
  }

  @override
  Future<void> updateProduct(
    String productId,
    Map<String, dynamic> changedFields,
    File? imageFile,
  ) async {
    debugPrint('=== Bắt đầu cập nhật sản phẩm qua API ===');
    changedFields.forEach((key, value) => debugPrint('  $key: $value'));
    if (imageFile != null) debugPrint('  Image Path: ${imageFile.path}');
    // Convert product thanh int

    final product_id = productId;
    final image;

    try {
      final formData = FormData.fromMap({
        ...changedFields,
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: basename(imageFile.path),
          )
      });

      print(formData);

      final response = await dio.post(
        '/products/v2/$product_id',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception('Cập nhật thất bại: ${response.statusCode}');
      }

      debugPrint('Cập nhật sản phẩm thành công!');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      if (status == 409) {
        throw Exception('Sản phẩm đã tồn tại');
      } else if (status == 400) {
        throw Exception('[400] ${data?['message'] ?? 'Yêu cầu không hợp lệ'}');
      } else if (status == 500) {
        throw Exception('[500] Lỗi máy chủ');
      } else {
        throw Exception(
            '[${status ?? 'Unknown'}] ${data?['message'] ?? e.message}');
      }
    } catch (e) {
      debugPrint('❌ Lỗi không xác định: $e');
      throw Exception('Đã có lỗi xảy ra: $e');
    } finally {
      debugPrint('=== Kết thúc cập nhật sản phẩm ===');
    }
  }

  @override
  Future<List<adminProductModel.ProductModel>> getProducts() async {
    try {
      final response = await dio.get('/products/v2');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        debugPrint('Data Length: ${data.length}');
        debugPrint('Sản phẩm đầu tiên: ${data[0]}');

        return data.where((json) => json is Map<String, dynamic>).map((json) {
          final jsonMap = Map<String, dynamic>.from(json);

          final variantList =
              jsonMap['variantProducts'] as List<dynamic>? ?? [];
          final variants = <String, double>{};

          for (final variant in variantList) {
            final variantId = variant['variant_id']?.toString();
            final price = (variant['discount_price'] as num?)?.toDouble() ?? 0;

            if (variantId != null) {
              variants[variantId] = price;
            }
          }

          jsonMap.remove('variantProducts'); // tránh lỗi fromJson
          jsonMap['variants'] = variants;
          
          debugPrint('${jsonMap['variants']}');

          return adminProductModel.ProductModel.fromJson(jsonMap);
        }).toList();
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await dio.delete('/products/$id');

      debugPrint("${response.statusCode}");
      if (response.statusCode != 200) {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      throw Exception('Failed to delete product: $e');
    }
  }
}
