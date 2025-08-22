// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/promotion/data/models/promotion_model.dart';

abstract class PromotionRemoteSource {
  Future<List<PromotionModel>> fetchPromotions();
  Future<bool> saveUserPromotion(int promotion_id, {bool? isPrivate});
  Future<List<PromotionModel>> getPromotions();
  Future<bool> createPromotion(PromotionModel promotion, [String? is_manual]);
  Future<PromotionModel?> SearchApplyPromotionByCode(String code);
  Future<List<PromotionModel>> getPrivatePromotions();
  Future<bool> sendPromotionForUser(int promotion_id, String user_id);
}

class PromotionRemoteSourceImpl implements PromotionRemoteSource {
  final Dio dio = DioClient().client;
  @override
  Future<List<PromotionModel>> fetchPromotions() async {
    try {
      print('📡 Đang gọi API promotion...');

      final response = await dio.get(
        '/promotions/public',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // 'Authorization': 'Bearer $token', // Thêm token nếu cần
          },
        ),
      );

      print('RESPONSE STATUS: ${response.statusCode}');
      print('Full response: ${response.data}');

      // Kiểm tra và xử lý dữ liệu an toàn hơn
      if (response.data == null ||
          response.data['result'] == null ||
          response.data['result']['data'] == null) {
        print('Cấu trúc dữ liệu không đúng');
        return [];
      }

      final data = response.data['result']['data'] as List;
      final list =
          data.map<PromotionModel>((e) => PromotionModel.fromJson(e)).toList();
      print('Số lượng promotion: ${list.length}');
      return list;
    } on DioException catch (e) {
      print('❌ Dio ERROR: ${e.message}');
      print('📨 Response: ${e.response?.data}');
      if (e.type == DioExceptionType.connectionTimeout) {
        print('❌ Lỗi kết nối timed out');
      } else if (e.type == DioExceptionType.connectionError) {
        print('❌ Không thể kết nối đến server');
      }
      rethrow;
    } catch (e) {
      print('❌ Lỗi không xác định: $e');
      rethrow;
    }
  }



  // Tang ma voucher cho user
  @override
  Future<bool> sendPromotionForUser(int promotion_id, String user_id) async {
    try {
      print("Dang goi api send Promotion ${promotion_id } cho user ${user_id} " ); 
      final response = await dio
          .post('/promotions/$user_id', data: {"promotion_id": promotion_id});

      print("${response.statusCode}");
      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print(' Dio ERROR: ${e.message}');
      print(' Response: ${e.response?.data}');
      if (e.type == DioExceptionType.connectionTimeout) {
        print(' Lỗi kết nối timed out');
      } else if (e.type == DioExceptionType.connectionError) {
        print(' Không thể kết nối đến server');
      }
      rethrow;
    } catch (e) {
      print(' Lỗi không xác định: $e');
      rethrow;
    }
  }

  @override
  Future<List<PromotionModel>> getPrivatePromotions() async {
    try {
      print('Đang gọi API promotion private...');

      final response = await dio.get('/promotions/private');

      print('RESPONSE STATUS: ${response.statusCode}');
      print('Full response: ${response.data}');

      // Kiểm tra và xử lý dữ liệu an toàn hơn
      if (response.data == null ||
          response.data['result'] == null ||
          response.data['result']['data'] == null) {
        print('Cấu trúc dữ liệu không đúng');
        return [];
      }

      final data = response.data['result']['data'] as List;
      final list =
          data.map<PromotionModel>((e) => PromotionModel.fromJson(e)).toList();
      print('Số lượng promotion: ${list.length}');
      return list;
    } on DioException catch (e) {
      print(' Dio ERROR: ${e.message}');
      print(' Response: ${e.response?.data}');
      if (e.type == DioExceptionType.connectionTimeout) {
        print(' Lỗi kết nối timed out');
      } else if (e.type == DioExceptionType.connectionError) {
        print(' Không thể kết nối đến server');
      }
      rethrow;
    } catch (e) {
      print(' Lỗi không xác định: $e');
      rethrow;
    }
  }

  @override
  Future<bool> saveUserPromotion(int promotionId, {bool? isPrivate}) async {
    print('Đang gọi API để lưu promotion user');

    try {
      final response = await dio.post(
        '/promotions',
        data: {
          "promotion_id": promotionId,
        },
      );

      print('RESPONSE STATUS: ${response.statusCode}');
      print(
          'Full response: ${response.data}'); // Printing the full response for debugging

      if (response.statusCode == 200 && response.data['success'] == true) {
        print('Save Promotion Successfully');
        return true;
      } else {
        print('SAVE PROMOTIONS FAILED');
        return false;
      }
    } on DioException catch (e) {
      // Handle specific Dio errors
      print('Dio ERROR: ${e.message}');
      print('📨 Response: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout) {
        print('Lỗi kết nối timed out');
      } else if (e.type == DioExceptionType.connectionError) {
        print('Không thể kết nối đến server');
      }
      throw Exception(
          'Failed to save promotion due to Dio error: ${e.message}');
    } catch (e) {
      // Handle other unknown errors
      print('Lỗi không xác định: $e');
      throw Exception('An unknown error occurred while saving the promotion');
    }
  }

  /// ---------- Get List Promotion cua user da luu ------------------------- ///
  @override
  Future<List<PromotionModel>> getPromotions() async {
    try {
      print('📡 Đang gọi API promotion...');

      final response = await dio.get(
        '/promotions/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // 'Authorization': 'Bearer $token', // Thêm token nếu cần
          },
        ),
      );

      print('RESPONSE STATUS: ${response.statusCode}');
      print('Full response: ${response.data}');

      // Kiểm tra và xử lý dữ liệu an toàn hơn
      if (response.data == null || response.data['data'] == null) {
        print('Cấu trúc dữ liệu không đúng');
        return [];
      }

      final data = response.data['data'] as List;
      final list =
          data.map<PromotionModel>((e) => PromotionModel.fromJson(e)).toList();
      print('Số lượng promotion: ${list.length}');
      print(list);
      return list;
    } on DioException catch (e) {
      print('Dio ERROR: ${e.message}');
      print('📨 Response: ${e.response?.data}');
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Lỗi kết nối timed out');
      } else if (e.type == DioExceptionType.connectionError) {
        print('Không thể kết nối đến server');
      }
      rethrow;
    } catch (e) {
      print('Lỗi không xác định: $e');
      rethrow;
    }
  }

  @override
  Future<bool> createPromotion(PromotionModel promotion,
      [String? is_manual]) async {
    try {
      final data = {
        'title': promotion.title,
        'description': promotion.description,
        'discount_type': promotion.discountType!.toUpperCase(),
        'discount_value': promotion.discountValue,
        'max_discount_value': promotion.maxDiscountValue,
        'min_order_value': promotion.minOrderValue,
        'applies_to': promotion.appliesTo,
        'product_id':
            promotion.appliesTo == 'PRODUCT' ? promotion.productId : null,
        'category_id':
            promotion.appliesTo == 'CATEGORY' ? promotion.categoryId : null,
        'start_date': promotion.startDate!.toIso8601String(),
        'end_date': promotion.endDate!.toIso8601String(),
        "usage_limit": promotion.usageLimit,
        'code': promotion.code,
        'is_active': promotion.isActive,
        "is_exclusive": promotion.isExclusive
      };
      data['is_manual'] = is_manual;

      print("ADMIN đang gọi api để tạo voucher");
      print("data: $data");
      final response = await dio.post('/promotions/create', data: data);
      print(response.statusCode);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      // Handle specific Dio errors
      print('Dio ERROR: ${e.message}');
      print('📨 Response: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout) {
        print('Lỗi kết nối timed out');
      } else if (e.type == DioExceptionType.connectionError) {
        print('Không thể kết nối đến server');
      }
      throw Exception(
          'Failed to save promotion due to Dio error: ${e.message}');
    } catch (e) {
      // Handle other unknown errors
      print('Lỗi không xác định: $e');
      throw Exception('An unknown error occurred while saving the promotion');
    }
  }

  @override
  Future<PromotionModel?> SearchApplyPromotionByCode(String code) async {
    try {
      final response = await dio.get("/promotions/public/$code");
      if (response.statusCode == 200) {
        final data = response.data['result'];
        if (data['success'] && data['data'] != null) {
          print(data['data']);
          return PromotionModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Mã khuyến mãi không hợp lệ');
        }
      }
      throw Exception('Phản hồi không hợp lệ từ server');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Lỗi kết nối timed out');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Không thể kết nối đến server');
      }
      throw Exception('Lỗi Dio: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}
