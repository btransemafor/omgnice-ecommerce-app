import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/models/user_model.dart';

// Ngoại lệ tùy chỉnh
class DataSourceException implements Exception {
  final String message;
  DataSourceException(this.message);
}

abstract class ProfileDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(UserModel profile, [bool? isAdd]);
  Future<bool> contactUs(Map<String, String> data, PlatformFile? attachment);
}

class ProfileRemoteDataSource implements ProfileDataSource {
  final Dio dio;

  ProfileRemoteDataSource({required this.dio});

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get('/users/profile');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw DataSourceException('Failed to load profile: Invalid response');
      }
    } on DioError catch (e) {
      throw DataSourceException(_handleDioError(e));
    } catch (e) {
      throw DataSourceException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile(UserModel profile, [bool? isAdd]) async {
    try {
      if (profile.name!.isEmpty) {
        throw DataSourceException('Profile name is required');
      }
      final response = await dio.put(
        '/users/profile',
        data: profile.toJson(),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          return UserModel.fromJson(response.data['data']);
        } else if (response.data['success'] == true) {
          return profile;
        } else {
          throw DataSourceException('Update failed: Invalid response format');
        }
      } else {
        throw DataSourceException(
            'Failed to update profile: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on DioError catch (e) {
      throw DataSourceException(_handleDioError(e));
    } catch (e) {
      throw DataSourceException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<bool> contactUs(Map<String, String> data, PlatformFile? attachment) async {
    try {
      // Tạo FormData để gửi dữ liệu và file
      final formData = FormData.fromMap({
        ...data,
        if (attachment != null)
          'attachment': await MultipartFile.fromFile(
            attachment.path!,
            filename: attachment.name,
          ),
      });

      final response = await dio.post(
        '/contacts',
        data: formData,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      } else {
        throw DataSourceException(
            'Failed to submit contact: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on DioError catch (e) {
      throw DataSourceException(_handleDioError(e));
    } catch (e) {
      throw DataSourceException('Unexpected error: ${e.toString()}');
    }
  }

  String _handleDioError(DioError error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      default:
        return 'Network error: ${error.message}';
    }
  }
}