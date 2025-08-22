import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({String? userId, bool isAdmin = false}) ;
  Future<NotificationEntity> markAsRead(String notificationId, [bool? isAdmin]);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId,[bool? isAdmin]);
  Future<void> deleteAllNotifications([bool? isAdmin]);
  Future<bool> createNotification(Map<String, String> noti);
  Future<void> markAllAdminNotificationsAsRead();
  Future<void> deleteAdminNotification(String notificationId);
}