import '../repositories/notification_repository.dart';

class DeleteAllNotificationsUseCase {
  final NotificationRepository repository;

  DeleteAllNotificationsUseCase({required this.repository});

  Future<void> execute([bool? isAdmin]) async {
    await repository.deleteAllNotifications(isAdmin);
  }
}