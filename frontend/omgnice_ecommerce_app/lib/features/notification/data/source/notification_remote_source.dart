/* // ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({String? userId, bool isAdmin = false});
  Future<NotificationModel> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllNotifications();
  Future<bool> createNotification(Map<String, String> noti);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<NotificationModel>> getNotifications({
  String? userId,
  bool isAdmin = false,
}) async {
  final endpoint = isAdmin ? '/notifications/admin' : '/notifications/';
  print("Endpoint: $endpoint");
  print("User ID: $userId");

  final response = await dio.get(
    endpoint,
    //queryParameters: (userId != null && !isAdmin) ? {'userId': userId} : null,
  );

  if (response.statusCode == 200) {
    final data = response.data;

    if (data == null) {
      throw Exception('No notifications found');
    }

    if (data is List) {
      return data.map((item) => NotificationModel.fromJson(item)).toList();
    } else if (data is Map) {
      return [NotificationModel.fromJson(Map<String, dynamic>.from(data))];
    } else {
      throw Exception('Unexpected data format');
    }
  } else {
    throw Exception('Failed to load notifications');
  }
}



  @override
  Future<NotificationModel> markAsRead(String notificationId) async {
    print("Đang tiến hành đánh dấu đã đọc thông báo");
    final response = await dio.patch(
      '/notifications/$notificationId/read',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data['success'] && data['data'] != null) {
        return NotificationModel.fromJson(data['data']);
      } else {
        throw Exception(
            data['message'] ?? 'Failed to mark notification as read');
      }
    } else {
      throw Exception('Failed to mark notification as read');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final response = await dio.patch(
      '/notifications/read-all',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (!data['success']) {
        throw Exception(
            data['message'] ?? 'Failed to mark all notifications as read');
      }
    } else {
      throw Exception('Failed to mark all notifications as read');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    print("Đang tiến hành xóa thông báo ${notificationId}");
    final response = await dio.delete(
      '/notifications/$notificationId',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (!data['success']) {
        throw Exception(data['message'] ?? 'Failed to delete notification');
      }
    } else {
      throw Exception('Failed to delete notification');
    }
  }

  @override
  Future<void> deleteAllNotifications() async {
    final response = await dio.delete(
      '/notifications',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (!data['success']) {
        throw Exception(
            data['message'] ?? 'Failed to delete all notifications');
      }
    } else {
      throw Exception('Failed to delete all notifications');
    }
  }

  @override
  Future<bool> createNotification(Map<String, String> noti) async {
    try {
      final response = await dio.post('/notifications', data: noti);
      print("____ STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return true; // e.g., {'success': true, 'message': 'Notification created'}
        } else {
          throw Exception(data['message'] ?? 'Failed to create notification');
        }
      } else {
        throw Exception(
            'Failed to create notification: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating notification: $e');
    }
  }
}
 */


import 'package:dio/dio.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({String? userId, bool isAdmin = false});
  Future<NotificationModel> markAsRead(String notificationId,[bool? isAdmin]);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId,[bool? isAdmin]);
  Future<void> deleteAllNotifications([bool? isAdmin]);
  Future<bool> createNotification(Map<String, String> noti);
  Future<void> markAllAdminNotificationsAsRead(); 
  Future<void> deleteAdminNotification(String notificationId); 
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;
  final String? authToken; // Thêm token để hỗ trợ xác thực

  NotificationRemoteDataSourceImpl({required this.dio, this.authToken}) {
    // Cấu hình header Authorization nếu có token
    if (authToken != null) {
      dio.options.headers['Authorization'] = 'Bearer $authToken';
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications({
    String? userId,
    bool isAdmin = false,
  }) async {
    final endpoint = isAdmin ? '/notifications/admin' : '/notifications';
    print('Fetching notifications from endpoint: $endpoint, userId: $userId');

    try {
      final response = await dio.get(
        endpoint,
        queryParameters: (!isAdmin && userId != null) ? {'userId': userId} : null,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data == null || data['success'] == false) {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data?['message'] ?? 'No notifications found',
          );
        }

        final notifications = data['data'];
        if (notifications is List) {
          return notifications
              .map((item) => NotificationModel.fromJson(item))
              .toList();
        } else if (notifications is Map) {
          return [NotificationModel.fromJson(Map<String, dynamic>.from(notifications))];
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            error: 'Unexpected data format',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to load notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  @override
  Future<NotificationModel> markAsRead(String notificationId,[bool? isAdmin]) async {
    print('Marking notification as read: $notificationId, isAdmin: $isAdmin');
    final endpoint = isAdmin == true
        ? '/notifications/admin//$notificationId/read'
        : '/notifications/$notificationId/read';
    print('Marking notification as read: $notificationId');
    print('Endpoint: $endpoint');

    try {
      final response = await dio.patch(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success']) {
          // Backend không trả về NotificationModel, giả lập cập nhật local
          return NotificationModel(
            userId: data['userId'] ?? '',
            id: notificationId,
            title: '',
            message: '',
            type: 'system',
            status: true,
            readAt: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to mark notification as read',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to mark notification as read: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final endpoint = '/notifications/read-all';
    print('Marking all notifications as read');

    try {
      final response = await dio.patch(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (!data['success']) {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to mark all notifications as read',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to mark all notifications as read: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error marking all notifications as read: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  @override
  Future<void> deleteNotification(String notificationId, [bool? isAdmin]) async {
    final endpoint = isAdmin == true
        ? '/notifications/admin/$notificationId'
        : '/notifications/$notificationId';
    print('Deleting notification: $notificationId');

    try {
      final response = await dio.delete(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (!data['success']) {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to delete notification',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to delete notification: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error deleting notification: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  @override
  Future<void> deleteAllNotifications([bool? isAdmin]) async {
    final endpoint = isAdmin == true
        ? '/notifications/admin'
        : '/notifications';
    print('Deleting all notifications');

    try {
      final response = await dio.delete(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (!data['success']) {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to delete all notifications',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to delete all notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error deleting all notifications: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  @override
  Future<bool> createNotification(Map<String, String> noti) async {
    const endpoint = '/notifications';
    print('Creating notification: $noti');

    try {
      final response = await dio.post(endpoint, data: noti);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return true;
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to create notification',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to create notification: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error creating notification: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  Future<void> markAllAdminNotificationsAsRead() async {
    const endpoint = '/notifications/admin/read-all';
    print('Marking all admin notifications as read');

    try {
      final response = await dio.patch(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (!data['success']) {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to mark all admin notifications as read',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to mark all admin notifications as read: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error marking all admin notifications as read: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAdminNotification(String notificationId) async {
    final endpoint = '/notifications/admin/$notificationId';
    print('Deleting admin notification: $notificationId');

    try {
      final response = await dio.delete(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (!data['success']) {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to delete admin notification',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to delete admin notification: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error deleting admin notification: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAllAdminNotifications() async {
    const endpoint = '/notifications/admin';
    print('Deleting all admin notifications');

    try {
      final response = await dio.delete(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (!data['success']) {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to delete all admin notifications',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to delete all admin notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error deleting all admin notifications: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }

  Future<bool> createAdminNotification({
    required String title,
    required String message,
    String type = 'system',
  }) async {
    const endpoint = '/notifications/admin';
    print('Creating admin notification: $title, $message, $type');

    try {
      final response = await dio.post(
        endpoint,
        data: {'title': title, 'message': message, 'type': type},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return true;
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            error: data['message'] ?? 'Failed to create admin notification',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to create admin notification: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error creating admin notification: $e');
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        error: e.toString(),
      );
    }
  }
}