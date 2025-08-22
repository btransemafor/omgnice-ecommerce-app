import 'package:omgnice_ecommerce_app/features/notification/domain/repositories/notification_repository.dart';

class CreateNotificationUsecase {
  final NotificationRepository notificationRepository; 
  const CreateNotificationUsecase({required this.notificationRepository}); 
  Future<bool> call(Map<String, String> noti) async {
   return await notificationRepository.createNotification(noti); 
  }
}