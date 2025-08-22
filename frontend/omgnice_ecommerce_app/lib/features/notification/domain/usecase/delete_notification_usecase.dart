import '../repositories/notification_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase({required this.repository});

  Future<void> execute(String notificationId,[bool? isAdmin]) async {
    await repository.deleteNotification(notificationId, isAdmin);
  }
}