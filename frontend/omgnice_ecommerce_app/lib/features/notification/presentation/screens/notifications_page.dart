import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/screens/list_widget.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Check user role, if admin then fetch all notifications
    // if user then fetch notifications by   userId
    WidgetsBinding.instance.addPostFrameCallback((_) {
    //  final userProvider = Provider.of<UserProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<NotificationProvider>(context, listen: false)
            .fetchNotifications();
      });
    });
  }

  void _markAllAsRead() {
    Provider.of<NotificationProvider>(context, listen: false).markAllAsRead();
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
            'Are you sure you want to clear all notifications? This action cannot be undone.'),
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
              Provider.of<NotificationProvider>(context, listen: false)
                  .deleteAllNotifications();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BeautifulAppBar(
        title: 'Notifications',
        gradient: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            tooltip: 'Mark all as read',
            onPressed: _markAllAsRead,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: 'Clear all notifications',
            onPressed: _clearAllNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false)
                  .fetchNotifications();
            },
          ),
        ],
      ),
      body: const NotificationListWidget(),
      backgroundColor: Colors.grey.shade50,
    );
  }
}
