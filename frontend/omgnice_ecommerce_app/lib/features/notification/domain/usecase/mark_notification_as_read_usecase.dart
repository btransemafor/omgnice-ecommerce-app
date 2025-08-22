import '../repositories/notification_repository.dart';
import '../entities/notification_entity.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase({required this.repository});

  Future<NotificationEntity> execute(String notificationId, [bool? isAdmin]) async {
    return await repository.markAsRead(notificationId, isAdmin);
  }
}