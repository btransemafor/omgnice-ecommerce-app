// Import [Banner_Model]
// ignore_for_file: avoid_print

import 'package:omgnice_ecommerce_app/core/constants/url.dart';
import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/home/data/models/banner_model.dart';
import 'package:dio/dio.dart';

abstract class HomeRemoteSource {
  Future<List<BannerModel>> getBanners();
  Future<bool> canSpinToday();
  Future<bool> createBanner(BannerModel newBanner);
  Future<bool> deleteBanner(int bannerId); 
}

class HomeRemoteSourceImpl implements HomeRemoteSource {
  final Dio dio = DioClient().client;

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await dio.get(
        "/banners",
      );

      if (response.statusCode == 200) {
        List<BannerModel> banners = (response.data['data'] as List)
            .map((banner) => BannerModel.fromJson(banner))
            .toList();

        print(response.data['data']);

        return banners;
      } else {
        throw Exception("Failed to load banners");
      }
    } on DioException catch (e) {
      throw Exception("Failed to load banners: ${e.message}");
    }
  }

  @override
  Future<bool> canSpinToday() async {
    try {
      final response = await dio.post(
        "/users/spin",
      );

      if (response.statusCode == 200) {
        return response.data['success'] == true;
      } else {
        return false;
        ///// throw Exception("Failed to check spin status");
      }
    } on DioException catch (e) {
      throw Exception("Failed to check spin status: ${e.message}");
    }
  }

  @override
  Future<bool> createBanner(BannerModel newBanner) async {
    try {
      // Log input BannerModel
      print('⚡ Creating banner with data: ${newBanner.toString()}');

      // Prepare payload with ISO 8601 dates and createdAt
      final data = {
        "title": newBanner.title,
        "imageUrl": newBanner.imageUrl
            ,
        "actionType": newBanner.actionType,
        "actionValue": newBanner.actionValue,
        "productId": newBanner.productId ?? null,
        "categoryId": newBanner.categoryId ?? null,
        "startTime": newBanner.startTime.toUtc().toIso8601String(),
        "endTime": newBanner.endTime.toUtc().toIso8601String(),
        "isLuckyWheelBanner": newBanner.isLuckyWheelBanner,
        "createdAt": DateTime.now().toUtc().toIso8601String(),
      };

      // Log payload
      print('⚡ Sending payload: $data');

      // Log Dio configuration
      print('⚡ Dio base URL: ${dio.options.baseUrl}');
      print('⚡ Requesting POST to endpoint: /banners');
      print('⚡ Request headers: ${dio.options.headers}');

      // Make API call with timeout
      final response = await dio
          .post(
        "/banners",
        data: data,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('⚡ Request timed out after 30 seconds');
          throw Exception('Request timed out');
        },
      );

      // Log response details
      print('⚡ Response status: ${response.statusCode}');
      print('⚡ Response data: ${response.data}');
      print('⚡ Response headers: ${response.headers}');

      // Check response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final success = response.data['success'] == true;
        print(
            '⚡ Banner creation ${success ? 'succeeded' : 'failed'}: ${response.data}');
        return success;
      } else {
        print('⚡ Unexpected status code: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      // Log detailed error
      print('⚡ DioException caught:');
      print('⚡ Error message: ${e.message}');
      print('⚡ Error type: ${e.type}');
      print('⚡ Response: ${e.response?.data}');
      print('⚡ Status code: ${e.response?.statusCode}');
      print('⚡ Request payload: ${e.requestOptions.data}');
      print('⚡ Request headers: ${e.requestOptions.headers}');
      print('⚡ Request base URL: ${e.requestOptions.baseUrl}');
      print('⚡ Stack trace: ${e.stackTrace}');
      if (e.type == DioExceptionType.connectionError) {
        print(
            '⚡ Network issue: Check internet connection or server availability');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        print('⚡ Timeout issue: Server may be slow or unreachable');
      }

      throw Exception(
          'Failed to create banner: ${e.message ?? 'Unknown error'}');
    } catch (e, stackTrace) {
      // Log unexpected errors
      print('⚡ Unexpected error: $e');
      print('⚡ Stack trace: $stackTrace');
      throw Exception('Failed to create banner: $e');
    }
  }

  @override
  Future<bool> deleteBanner(int bannerId) async {
    try {
      print('⚡ Deleting banner with ID: $bannerId');
      print('⚡ Requesting DELETE to endpoint: /banners/$bannerId');
      print('⚡ Request headers: ${dio.options.headers}');

      final response = await dio.delete('/banners/$bannerId').timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print('⚡ Request timed out after 15 seconds');
          throw Exception('Request timed out');
        },
      );

      print('⚡ Response status: ${response.statusCode}');
      print('⚡ Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('⚡ Banner deletion succeeded: ${response.data}');
        return true;
      } else {
        print('⚡ Unexpected status code: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('⚡ DioException caught:');
      print('⚡ Error message: ${e.message}');
      print('⚡ Error type: ${e.type}');
      print('⚡ Response: ${e.response?.data}');
      print('⚡ Status code: ${e.response?.statusCode}');
      print('⚡ Request URL: ${e.requestOptions.uri}');
      print('⚡ Stack trace: ${e.stackTrace}');
      throw Exception(
          'Failed to delete banner: ${e.message ?? 'Unknown error'}');
    } catch (e, stackTrace) {
      print('⚡ Unexpected error: $e');
      print('⚡ Stack trace: $stackTrace');
      throw Exception('Failed to delete banner: $e');
    }
  }
}
