// lib/domain/entities/notification_entity.dart
class NotificationEntity {
  final String id;
  String? userId;
  final String title;
  final String message;
  final String type;
  final bool status;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.status,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    bool? status,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      status: status ?? this.status,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  NotificationEntity markAsRead() {
    return copyWith(
      status: true,
      readAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}