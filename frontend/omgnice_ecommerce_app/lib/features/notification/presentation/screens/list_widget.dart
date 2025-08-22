import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationListWidget extends StatelessWidget {
  final bool isAdmin;
  const NotificationListWidget({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; 
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    final bool isLargeScreen = screenWidth >= 600;

    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${provider.error}',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: isSmallScreen ? 13 : 15,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    provider.fetchNotifications();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off,
                  size: isSmallScreen ? 36 : 44,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15 : 17,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
          itemCount: provider.notifications.length,
          itemBuilder: (context, index) {
            final notification = provider.notifications[index];
            return NotificationItem(
              notification: notification,
              onTap: () {

                showBeautifulNotificationBottomSheet(context, size, notification );
                if (!notification.status) {
                  if (isAdmin) {
                    // If this is an admin notification, pass true
                    provider.markAsRead(notification.id, true);
                  } else {
                    // For user notifications, pass false
                    provider.markAsRead(notification.id);
                  }
                }
              },
              onMarkAsRead: () {
                if (isAdmin) {
                  // If this is an admin notification, pass true
                  print("--------- Đang tiến hành đánh đã đọc thông báo ${notification.id} - ADMIN");
                  provider.markAsRead(notification.id, true);
                } else {
                  // For user notifications, pass false
                  provider.markAsRead(notification.id);
                }
              },
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Notification'),
                    content: const Text('Are you sure you want to delete this notification?'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (isAdmin) {
                            // If this is an admin notification, pass true
                            provider.deleteNotification(notification.id, true);
                          } else {
                            // For user notifications, pass false
                            provider.deleteNotification(notification.id, false);
                          }
                     
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );
              },
              isSmallScreen: isSmallScreen,
              isLargeScreen: isLargeScreen,
            );
          },
        );
      },
    );
  }
}
void showBeautifulNotificationBottomSheet(BuildContext context, Size size, NotificationEntity notification) {
  // Configure icon and colors based on type
  Map<String, dynamic> getNotificationConfig(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return {
          'icon': Icons.check_circle_rounded,
          'color': Colors.green,
          'gradient': [Colors.green.shade50, Colors.green.shade100],
          'bgColor': Colors.green.shade50,
        };
      case 'warning':
        return {
          'icon': Icons.warning_amber_rounded,
          'color': Colors.orange,
          'gradient': [Colors.orange.shade50, Colors.orange.shade100],
          'bgColor': Colors.orange.shade50,
        };
      case 'error':
        return {
          'icon': Icons.error_rounded,
          'color': Colors.red,
          'gradient': [Colors.red.shade50, Colors.red.shade100],
          'bgColor': Colors.red.shade50,
        };
      case 'info':
        return {
          'icon': Icons.info_rounded,
          'color': Colors.blue,
          'gradient': [Colors.blue.shade50, Colors.blue.shade100],
          'bgColor': Colors.blue.shade50,
        };
      case 'promotion':
        return {
          'icon': Icons.local_offer_rounded,
          'color': Colors.purple,
          'gradient': [Colors.purple.shade50, Colors.purple.shade100],
          'bgColor': Colors.purple.shade50,
        };
      default:
        return {
          'icon': Icons.notifications_rounded,
          'color': const Color.fromARGB(255, 41, 167, 79),
          'gradient': [Colors.blue.shade50, const Color.fromARGB(255, 69, 244, 122)],
          'bgColor': Colors.blue.shade50,
        };
    }
  }

  final config = getNotificationConfig(notification.type);
  final isRead = notification.status;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with icon and status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon container with gradient background
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: config['gradient'],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: config['color'].withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              config['icon'],
                              color: config['color'],
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Title and status
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isRead 
                                        ? Colors.grey.shade100 
                                        : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isRead 
                                          ? Colors.grey.shade300
                                          : Colors.blue.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isRead 
                                            ? Icons.mark_email_read_rounded
                                            : Icons.mark_email_unread_rounded,
                                        size: 12,
                                        color: isRead 
                                            ? Colors.grey.shade600
                                            : Colors.blue.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isRead ? 'Read' : 'Unread',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: isRead 
                                              ? Colors.grey.shade600
                                              : Colors.blue.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Title
                                Text(
                                  notification.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: config['bgColor'],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: config['color'].withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.label_rounded,
                              size: 14,
                              color: config['color'],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              notification.type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: config['color'],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Message content
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.message_rounded,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Content',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              notification.message,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Time information
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade100,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Created time
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 16,
                                  color: const Color.fromARGB(255, 28, 120, 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Created at:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromARGB(255, 9, 134, 24),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  format(notification.createdAt),
                                  style: TextStyle(
                                    fontSize: 13,
                                      color: Colors.green.shade600,
                                  ),
                                ),
                              ],
                            ),
                            
                            if (notification.readAt != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.visibility_rounded,
                                    size: 16,
                                    color: Colors.green.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Read at:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    format(notification.readAt!),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          // Close button
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 50,
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey.shade100,
                                  foregroundColor: Colors.grey.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.close_rounded, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'Close',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Mark as read/unread button
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle mark as read/unread
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shadowColor: config['color'].withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isRead 
                                          ? Icons.mark_email_unread_rounded
                                          : Icons.mark_email_read_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isRead ? 'Mark as Unread' : 'Mark as Read',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
// Helper function để format datetime

String format(DateTime? time) {
  if (time == null) return "undefined";
  return DateFormat('dd-MM-yyyy, HH:mm:ss').format(time.toLocal());
}


class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;
  final bool isSmallScreen;
  final bool isLargeScreen;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
    required this.isSmallScreen,
    required this.isLargeScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 10 : 14,
          vertical: isSmallScreen ? 2 : 3,
        ),
        padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
        decoration: BoxDecoration(
          color: notification.status ? Colors.white : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getNotificationIcon(),
            SizedBox(width: isSmallScreen ? 8 : 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.status ? FontWeight.w500 : FontWeight.w700,
                      fontSize: isSmallScreen ? 13 : 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 13,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(notification.createdAt),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: isSmallScreen ? 10 : 11,
                        ),
                      ),
                      Row(
                        children: [
                          if (!notification.status)
                            TextButton(
                              onPressed: onMarkAsRead,
                              child: Text(
                                'Mark as Read',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: isSmallScreen ? 10 : 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          TextButton(
                            onPressed: onDelete,
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: isSmallScreen ? 10 : 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!notification.status)
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: isSmallScreen ? 7 : 8,
                height: isSmallScreen ? 7 : 8,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getNotificationIcon() {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'order':
        iconData = Icons.shopping_bag_outlined;
        iconColor = Colors.green.shade600;
        break;
      case 'system':
        iconData = Icons.notifications_outlined;
        iconColor = Colors.blue.shade600;
        break;
      default:
        iconData = Icons.notifications_none;
        iconColor = Colors.grey.shade600;
    }

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 7 : 8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: isSmallScreen ? 22 : 24,
      ),
    );
  }


  String _formatDate(DateTime? time) {
  if (time == null) return "undefined";
  return DateFormat('dd-MM-yyyy, HH:mm:ss').format(time.toLocal());
}
}



