import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// Notification model class
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool status;
  final String? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      status: json['status'],
      readAt: json['read_at'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

// Modern Notification Card Widget
class ModernNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final Function() onTap;
  final Function() onMarkAsRead;

  const ModernNotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Icon based on notification type
    IconData notificationIcon;
    Color iconBgColor;
    Color iconColor = Colors.white;

    switch (notification.type) {
      case 'order':
        notificationIcon = Icons.local_shipping_outlined;
        iconBgColor = Colors.green[600]!;
        break;
      case 'system':
        notificationIcon = Icons.notifications_outlined;
        iconBgColor = Colors.blue[600]!;
        break;
      case 'promo':
        notificationIcon = Icons.local_offer_outlined;
        iconBgColor = Colors.orange[600]!;
        break;
      default:
        notificationIcon = Icons.circle_notifications_outlined;
        iconBgColor = Colors.purple[600]!;
    }

    // Format time for display - using timeago package
    final timeAgo = timeago.format(notification.createdAt, locale: 'en_short');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: notification.status ? Colors.white : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notificationIcon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title with unread dot indicator
                          Expanded(
                            child: Row(
                              children: [
                                if (!notification.status)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.green[600],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: GoogleFonts.poppins(
                                      fontWeight: notification.status ? FontWeight.w500 : FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Time ago
                          Text(
                            timeAgo,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Message
                      Text(
                        notification.message,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Tag and Mark as Read button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Type tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: iconBgColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              notification.type.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: iconBgColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Mark as read button (only shown if unread)
                          if (!notification.status)
                            TextButton(
                              onPressed: onMarkAsRead,
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Mark as read',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Notification List Screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchNotifications();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Sample fetch notifications method
  Future<void> _fetchNotifications() async {
    // Simulating API fetch delay
    setState(() => _isLoading = true);
    
    // Mock data - in real app, you would fetch from API
    await Future.delayed(const Duration(seconds: 1));
    
    final List<dynamic> mockData = [
      {
        "id": "d1adffcc-9abc-4ad9-ac1c-db1fad8f4f04",
        "user_id": "70b1551f-e37a-4320-baca-b7e1103d79f7",
        "title": "Your order has been delivered",
        "message": "Please rate your experience. ⭐️",
        "type": "order",
        "status": false,
        "read_at": null,
        "createdAt": "2025-05-20T13:19:35.261Z",
        "updatedAt": "2025-05-20T13:19:35.261Z"
      },
      {
        "id": "764a5c1d-32aa-4f3c-9e6c-5965d85cc88e",
        "user_id": "70b1551f-e37a-4320-baca-b7e1103d79f7",
        "title": "Welcome to OMGNice!",
        "message": "Thanks for signing up. Happy to have you! ❤️",
        "type": "system",
        "status": false,
        "read_at": null,
        "createdAt": "2025-05-20T13:19:35.260Z",
        "updatedAt": "2025-05-20T13:19:35.260Z"
      },
      {
        "id": "d677d044-977b-46fc-8318-8ace6f254cf4",
        "user_id": "70b1551f-e37a-4320-baca-b7e1103d79f7",
        "title": "Welcome to OMGNice!",
        "message": "Thanks for signing up. Happy to have you! ❤️",
        "type": "system",
        "status": false,
        "read_at": null,
        "createdAt": "2025-05-20T13:18:34.958Z",
        "updatedAt": "2025-05-20T13:18:34.958Z"
      },
      {
        "id": "be547790-a657-44dd-81db-2169568088d3",
        "user_id": "70b1551f-e37a-4320-baca-b7e1103d79f7",
        "title": "Your order has been delivered",
        "message": "Please rate your experience. ⭐️",
        "type": "order",
        "status": false,
        "read_at": null,
        "createdAt": "2025-05-20T13:18:34.958Z",
        "updatedAt": "2025-05-20T13:18:34.958Z"
      }
    ];
    
    setState(() {
      _notifications.clear();
      _notifications.addAll(
        mockData.map((json) => NotificationModel.fromJson(json)).toList()
      );
      _isLoading = false;
    });
  }
  
  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedNotification = NotificationModel(
          id: _notifications[index].id,
          userId: _notifications[index].userId,
          title: _notifications[index].title,
          message: _notifications[index].message,
          type: _notifications[index].type,
          status: true, // Mark as read
          readAt: DateTime.now().toIso8601String(),
          createdAt: _notifications[index].createdAt,
          updatedAt: DateTime.now(),
        );
        _notifications[index] = updatedNotification;
      }
    });
    
    // In real app, you would call an API to update status
    // apiService.markNotificationAsRead(id);
  }
  
  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].status) {
          _notifications[i] = NotificationModel(
            id: _notifications[i].id,
            userId: _notifications[i].userId,
            title: _notifications[i].title,
            message: _notifications[i].message,
            type: _notifications[i].type,
            status: true,
            readAt: DateTime.now().toIso8601String(),
            createdAt: _notifications[i].createdAt,
            updatedAt: DateTime.now(),
          );
        }
      }
    });
    
    // In real app, you would call an API to update all statuses
    // apiService.markAllNotificationsAsRead();
  }
  
  List<NotificationModel> _getFilteredNotifications(String filter) {
    if (filter == 'all') {
      return _notifications;
    } else {
      return _notifications.where((item) => item.type == filter).toList();
    }
  }
  
  int _getUnreadCount() {
    return _notifications.where((item) => !item.status).length;
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _getUnreadCount();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final fontSizeBase = isSmallScreen ? 14.0 : 16.0;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[700],
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: fontSizeBase + 2,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: fontSizeBase, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Read All',
                style: GoogleFonts.poppins(
                  fontSize: fontSizeBase - 2,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(
            fontSize: fontSizeBase - 2,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: fontSizeBase - 2,
            fontWeight: FontWeight.w500,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'System'),
            Tab(text: 'Order'),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          )
        : _notifications.isEmpty
          ? _buildEmptyState()
          : TabBarView(
              controller: _tabController,
              children: [
                // All notifications tab
                _buildNotificationList(_getFilteredNotifications('all')),
                // System notifications tab
                _buildNotificationList(_getFilteredNotifications('system')),
                // Order notifications tab
                _buildNotificationList(_getFilteredNotifications('order')),
              ],
            ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something new arrives',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchNotifications,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Refresh',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications in this category',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _fetchNotifications,
      color: Colors.green[700],
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ModernNotificationCard(
            notification: notification,
            onTap: () {
              // Handle notification tap - could navigate to a detail page
              // or perform an action based on notification type
              if (!notification.status) {
                _markAsRead(notification.id);
              }
              
              // Example navigation based on type
              if (notification.type == 'order') {
                // Navigate to order details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navigating to order details'),
                    backgroundColor: Colors.green[700],
                  ),
                );
              }
            },
            onMarkAsRead: () => _markAsRead(notification.id),
          );
        },
      ),
    );
  }
}