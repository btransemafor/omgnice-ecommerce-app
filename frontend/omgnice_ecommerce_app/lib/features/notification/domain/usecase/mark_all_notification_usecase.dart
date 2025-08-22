import '../repositories/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsAsReadUseCase({required this.repository});

  Future<void> execute() async {
    await repository.markAllAsRead();
  }
}