// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:omgnice_ecommerce_app/features/user/data/models/user_stats.dart';

abstract class UserRemoteSource {
  Future<UserStatsModel> getStatisticUser(String user_id);
  Future<bool> updateUser(Map<String, String> updateData, [String? user_id]);
  Future<UserModel> getProfileUser([String? user_id]);
  Future<List<UserModel>> fetchAllUser();
  //  Thêm
  Future<bool> updateUserPoint(int amount);
  Future<bool> deleteUser([String? user_id]);
}

class UserRemoteSourceImpl extends UserRemoteSource {
  final Dio dio;
  UserRemoteSourceImpl({required this.dio});

  @override
  Future<UserStatsModel> getStatisticUser(String user_id) async {
    try {
      final response = await dio.get(
        '/users/statistics/$user_id',
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserStatsModel.fromJson(data);
      } else {
        throw Exception("No data or error status code");
      }
    } catch (e) {
      print("Error in getStatisticUser: $e");
      rethrow;
    }
  }

  Future<bool> updateUser(Map<String, String> updateData,
      [String? userId]) async {
    print("Đang update dữ liệu");
    print(updateData);
    try {
      final url = userId != null ? '/users/$userId' : '/users/profile';

      final response = await dio.put(
        url,
        data: updateData,
      );

      print(url);
      print('PUT $url -> ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 403) {
        throw Exception('Bạn không có quyền thực hiện hành động này.');
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      } else {
        print('Update failed: ${response.statusCode} - ${response.data}');
        throw Exception(response.data['message'] ?? 'Cập nhật thất bại.');
      }
    } catch (e) {
      print('Error in updateUser: $e');
      if (e is DioError && e.response?.statusCode == 403) {
        throw Exception('Bạn không có quyền thực hiện hành động này.');
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> getProfileUser([String? user_id]) async {
    try {
      print("Đang Fetch dữ liệu Profile mới nhất trong database nè !");

      final url = (user_id != null && user_id.isNotEmpty)
          ? '/users/profile/$user_id'
          : '/users/profile/';

      // { includeStatistics: req.query.includeStatistics }

      final response = await dio.get(
        url,
        queryParameters: {'includeStatistics': 'true'},
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = response.data['data'];

        print(data);
        return UserModel.fromJson(data);
      } else {
        throw Exception("Failed to fetch user profile");
      }
    } catch (error) {
      print('Error fetching profile: $error');
      rethrow; // properly rethrows in catch block
    }
  }

  @override
  Future<List<UserModel>> fetchAllUser() async {
    try {
      print("ADMIN - TUI ĐANG FETCH TẤT CẢ DỮ LIỆU CỦA USER NÈ!!!!");
      // Cách 1:  final response = await dio.get('/users?includeStatistics=true');
      // Cách 2: queryParameters
      final response = await dio.get(
        "/users",
        queryParameters: {'includeStatistics': 'true'},
      );
      print("${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        print('Check thử coi có dữ liệu không nhé: ${data[1]}');
        return data.map((item) => UserModel.fromJson(item)).toList();
      } else {
        throw Exception("Failed to fetch list user profile");
      }
    } catch (error) {
      print('Error fetching profile: $error');
      rethrow; // properly rethrows in catch block
    }
  }

  @override
  Future<bool> updateUserPoint(int amount) async {
    try {
      print(amount);
      final endpoint =
          amount >= 0 ? '/users/point/add' : '/users/point/subtract';

      final response = await dio.post(
        endpoint,
        data: {'amount': amount.abs()}, // Luôn truyền giá trị dương
      );

      print("POST $endpoint -> ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Cập nhật điểm thành công");
        return true;
      } else {
        print("Thất bại khi cập nhật điểm: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print('Exception in updateUserPoint: $e');
      return false;
    }
  }

@override
Future<bool> deleteUser([String? user_id]) async {
  try {
    print("Attempting to delete user. user_id: $user_id");
   // print(url); 

    // Nếu user_id null thì xóa user hiện tại (self-delete), ngược lại xóa user theo ID
    final url = (user_id != null && user_id.isNotEmpty)
        ? '/users/$user_id'
        : '/users/';

    final response = await dio.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete user");
    }
  } catch (error) {
    print('Error deleting user: $error');
    rethrow;
  }
}

}
