// lib/domain/usecases/get_notifications_usecase.dart
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase({required this.repository});
  Future<List<NotificationEntity>> execute({String? userId, bool isAdmin = false}) async {
    return repository.getNotifications(userId: userId, isAdmin: isAdmin);
  }
}
