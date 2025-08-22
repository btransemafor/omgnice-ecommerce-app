import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/reviews/data/models/review.dart';

abstract class ReviewRemoteSource {
  Future<List<ReviewModel>> getReviews(int product_id);
  Future<bool> createReview(Map<String, String> review);
}

class ReviewRemoteSourceImpl implements ReviewRemoteSource {
  final Dio dio;

  ReviewRemoteSourceImpl(this.dio);
  @override
  Future<List<ReviewModel>> getReviews(int product_id) async {
    try {
      debugPrint("Đang gọi tới API endpoint");
      final response = await dio.get('/products/$product_id/reviews');
      debugPrint('${response.statusCode}');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        print(data);
        return data
            .map((item) => ReviewModel(
                  id: item['id'],
                  userId: item['user_id'],
                  orderLineId: item['order_line_id'],
                  ratingStar: item['rating_star'],
                  comment: item['comment'] ?? '',
                  reviewDate: DateTime.parse(item['review_date']),
                  productId: item['product_id'],
                  variantId: item['variant_id'],
                  userName: item['user']?['name'] ?? 'Unknown',
                  userAvatar: item['user']?['avatar'] ??
                      "https://res.cloudinary.com/dehehzz2t/image/upload/v1745651286/download_e4ryfq.png",
                ))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception("Failed to load banners: ${e.message}");
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception("An unexpected error occurred");
    }
  }

  @override
  Future<bool> createReview(Map<String, dynamic> review) async {
    try {
      debugPrint("Đang gọi tới API POST /review với data: $review");

      final response = await dio.post(
        '/review',
        data: review,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      debugPrint(' Dio error: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return false;
    }
  }
}
