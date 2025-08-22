import 'package:flutter/foundation.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/create_notification_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/delete_all_notification_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/fetch_notifications_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/mark_all_noti_read_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/mark_all_notification_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/delete_notification_usecase.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationProvider extends ChangeNotifier {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase _markAllNotificationsAsReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final DeleteAllNotificationsUseCase _deleteAllNotificationsUseCase;
  final CreateNotificationUsecase _createNotificationUsecase;
  final MarkAllAdminNotificationsAsReadUseCase
      _markAllAdminNotificationsAsReadUseCase;

  List<NotificationEntity> _notifications = [];
  bool _isLoading = false;
  String? _error;
  bool _isSuccess = false;
  bool get isSucess => _isSuccess;

  NotificationProvider({
    required MarkAllAdminNotificationsAsReadUseCase
        markAllAdminNotificationsAsReadUseCase,
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
    required MarkAllNotificationsAsReadUseCase
        markAllNotificationsAsReadUseCase,
    required DeleteNotificationUseCase deleteNotificationUseCase,
    required DeleteAllNotificationsUseCase deleteAllNotificationsUseCase,
    required CreateNotificationUsecase createNotificationUsecase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
        _markAllNotificationsAsReadUseCase = markAllNotificationsAsReadUseCase,
        _deleteNotificationUseCase = deleteNotificationUseCase,
        _deleteAllNotificationsUseCase = deleteAllNotificationsUseCase,
        _createNotificationUsecase = createNotificationUsecase,
        _markAllAdminNotificationsAsReadUseCase =
            markAllAdminNotificationsAsReadUseCase;

  List<NotificationEntity> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount =>
      _notifications.where((notification) => !notification.status).length;

  Future<void> fetchNotifications(
      {String? userId, bool isAdmin = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    print("Đang get thông báo của user ");

    try {
      _notifications = await _getNotificationsUseCase.execute(
          userId: userId, isAdmin: isAdmin);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId, [bool? isAdmin]) async {
    print("--------- Đang tiến hành đánh đã đọc thông báo $notificationId - Admin: $isAdmin");
    try {
      // Optimistic update
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final oldNotification = _notifications[index];
        _notifications[index] = _notifications[index].copyWith(status: true);
        notifyListeners();

        final updatedNotification = await _markNotificationAsReadUseCase
            .execute(notificationId, isAdmin);
        _notifications[index] = updatedNotification;
        notifyListeners();
      }
    } catch (e) {
      // Rollback on error
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(status: false);
      }
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createNotifilcation(Map<String, String> noti) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi use case
      _isSuccess = await _createNotificationUsecase.call(noti);
      // Thêm vào đầu danh sách nếu muốn cập nhật UI ngay
      //  _notifications.insert(0, created);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    final oldNotifications = List<NotificationEntity>.from(_notifications);
    try {
      // Optimistic update
      _notifications =
          _notifications.map((n) => n.copyWith(status: true)).toList();
      notifyListeners();

      await _markAllNotificationsAsReadUseCase.execute();
    } catch (e) {
      // Rollback on error
      _notifications = oldNotifications;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String notificationId,
      [bool? isAdmin]) async {
    int index = -1;
    NotificationEntity? oldNotification;
    print("Đang tiến hành xóa thông báo ${notificationId}");
    try {
      // Optimistic update
      index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        oldNotification = _notifications[index];
        _notifications.removeAt(index);
        notifyListeners();

        await _deleteNotificationUseCase.execute(notificationId, isAdmin);
      }
    } catch (e) {
      // Rollback on error
      if (index != -1 && oldNotification != null) {
        _notifications.insert(index, oldNotification);
      }
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteAllNotifications([bool? isAdmin]) async {
    print("Đang tiến hành xóa tất cả thông báo - Admin: $isAdmin");
    final oldNotifications = List<NotificationEntity>.from(_notifications);
    try {
      // Optimistic update
      _notifications.clear();
      notifyListeners();

      await _deleteAllNotificationsUseCase.execute(isAdmin);
    } catch (e) {
      // Rollback on error
      _notifications = oldNotifications;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Admin
  Future<void> markAllAdminNotificationsAsRead() async {
    try {
      await _markAllAdminNotificationsAsReadUseCase.call();
      // Cập nhật trạng thái của tất cả thông báo admin
      _notifications =
          _notifications.map((n) => n.copyWith(status: true)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
