import 'package:omgnice_ecommerce_app/features/notification/data/source/notification_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/repositories/notification_repository.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource dataSource;

  NotificationRepositoryImpl(this.dataSource);

  @override
  Future<List<NotificationEntity>> getNotifications({String? userId, bool isAdmin = false}) async {
    try {
      final notifications = await dataSource.getNotifications(userId: userId, isAdmin: isAdmin);
      return notifications.map((notification) => NotificationEntity(
        id: notification.id,
        userId: notification.userId,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        status: notification.status,
        createdAt: notification.createdAt,
        updatedAt: notification.updatedAt,
      )).toList();
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }

  @override
  Future<NotificationEntity> markAsRead(String notificationId,[bool? isAdmin]) async {
    try {
      print("Đang đánh dấu thông báo là đã đọc $isAdmin");
      final notification = await dataSource.markAsRead(notificationId, isAdmin);
      NotificationEntity notifi = NotificationEntity(
        id: notification.id, 
        userId: notification.userId, 
        title: notification.title, 
        message: notification.message, 
        type: notification.type, 
        status: notification.status, 
        createdAt: notification.createdAt, 
        updatedAt: notification.updatedAt); 
      return notifi as NotificationEntity ; 
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dataSource.markAllAsRead();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId,[bool? isAdmin]) async {
    try {
      await dataSource.deleteNotification(notificationId, isAdmin);
    } catch (e) {
      throw Exception('Failed to delete notification: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAllNotifications([bool? isAdmin]) async {
    try {
      await dataSource.deleteAllNotifications(isAdmin);
    } catch (e) {
      throw Exception('Failed to delete all notifications: ${e.toString()}');
    }
  }

  @override
  Future<bool> createNotification(Map<String, String> noti) async {
    try {
     return await dataSource.createNotification(noti); 
    }
    catch (e) {
      throw Exception('Failed to delete all notifications: ${e.toString()}');
    }
  }

    @override
  Future<void> markAllAdminNotificationsAsRead() async {
    try {
      await dataSource.markAllAdminNotificationsAsRead(); 
    } catch (e) {
      throw Exception('Failed to mark all admin notifications as read: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAdminNotification(String notificationId) async {
    try {
      await dataSource.deleteAdminNotification(notificationId);
    } catch (e) {
      throw Exception('Failed to delete admin notification: ${e.toString()}');
    }
  }
}