import 'package:omgnice_ecommerce_app/features/notification/domain/repositories/notification_repository.dart';

class MarkAllAdminNotificationsAsReadUseCase {
  final NotificationRepository repository;

  MarkAllAdminNotificationsAsReadUseCase({required this.repository});

  Future<void> call() async {
    await repository.markAllAdminNotificationsAsRead();
  }

}
