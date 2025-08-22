import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/screens/notifications_page.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';

class NotificationBellWidget extends StatefulWidget {
  final Function()? onTap;
  final Color iconColor;
  final double iconSize;
  final Color badgeColor;
  final Color badgeTextColor;

  const NotificationBellWidget({
    Key? key,
    this.onTap,
    this.iconColor = Colors.white,
    this.iconSize = 25,
    this.badgeColor = Colors.red,
    this.badgeTextColor = Colors.white,
  }) : super(key: key);

  @override
  State<NotificationBellWidget> createState() => _NotificationBellWidgetState();
}

class _NotificationBellWidgetState extends State<NotificationBellWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Shorter for smoother shaking
    );

    // Create scale animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.15), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.15, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Create subtle rotation animation
    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0.04), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.04, end: -0.04), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -0.04, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Fetch notifications if empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      if (notificationProvider.notifications.isEmpty && !notificationProvider.isLoading) {
        notificationProvider.fetchNotifications();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {
        final notificationCount = notificationProvider.notifications.length;
        final unreadCount = notificationProvider.unreadCount;

        // Control animation based on unread count
        if (unreadCount > 0 && !_animationController.isAnimating) {
          _animationController.repeat(reverse: true);
        } else if (unreadCount == 0 && _animationController.isAnimating) {
          _animationController.stop();
          _animationController.reset();
        }

        // Optional debug print to verify counts
        // print('Notification count: $notificationCount, Unread count: $unreadCount');

        return GestureDetector(
          onTap: widget.onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: unreadCount > 0
                        ? [
                            BoxShadow(
                              color: widget.badgeColor.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Transform.scale(
                        scale: unreadCount > 0 ? _scaleAnimation.value : 1.0,
                        child: Icon(
                          Icons.notifications_none_outlined,
                          color: widget.iconColor,
                          size: widget.iconSize,
                        ),
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: widget.badgeColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Center(
                              child: Text(
                                notificationCount > 9 ? '9+' : '$notificationCount',
                                style: TextStyle(
                                  color: widget.badgeTextColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Usage example for HomeAppBar
Widget buildNotificationButton(BuildContext context, Function()? onTap) {
  return NotificationBellWidget(
    onTap: onTap,
    iconColor: Colors.white,
    badgeColor: Colors.red,
  );
}