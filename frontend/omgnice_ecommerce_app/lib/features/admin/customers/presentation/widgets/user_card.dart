import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class PremiumUserCard extends StatefulWidget {
  final String id;
  final String name;
  final String phone;
  final String avatarUrl;
  final int totalOrders;
  final int totalSpending;
  final int points;
  final String rank;
  final String status;
  final DateTime? lastOrderDate;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  const PremiumUserCard({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.totalOrders,
    required this.totalSpending,
    required this.points,
    required this.rank,
    required this.status,
    this.lastOrderDate,
    this.onTap,
    this.onToggleStatus,
    this.onCall,
    this.onMessage,
  });

  @override
  State<PremiumUserCard> createState() => _PremiumUserCardState();
}

class _PremiumUserCardState extends State<PremiumUserCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return 'No orders yet';
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays >= 7) return '${diff.inDays ~/ 7}w ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '').format(amount);
  }

  Color _getRankColor(String rank) {
    switch (rank.toLowerCase()) {
      case 'diamond':
        return const Color(0xFF8E44AD);
      case 'platinum':
        return const Color(0xFF2C3E50);
      case 'gold':
        return const Color(0xFFE67E22);
      case 'silver':
        return const Color(0xFF95A5A6);
      case 'bronze':
        return const Color(0xFFBDC3C7);
      default:
        return const Color(0xFF3498DB);
    }
  }

  /// Get Rank
  // Lon hon 500 điểm => Rank diamond
  String getNameRankBasedPoint(int point) {
    if (point >= 150 && point < 200) {
      return 'bronze';
    } else if (point >= 200 && point < 350) {
      return 'silver';
    } else if (point >= 350 && point < 450) {
      return 'gold';
    } else if (point >= 450 && point < 900) {
      return 'platinum';
    } else if (point >= 900) {
      return 'diamond';
    } else {
      return 'No rank';
    }
  }

  IconData _getRankIcon(String rank) {
    switch (rank.toLowerCase()) {
      case 'diamond':
        return Icons.diamond;
      case 'platinum':
        return Icons.workspace_premium;
      case 'gold':
        return Icons.emoji_events;
      case 'silver':
        return Icons.military_tech;
      case 'bronze':
        return Icons.stars;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.status.toLowerCase() == 'active';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final orders = orderProvider.order;
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
     /*  onTap: () => {
        
      }, */
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color.fromARGB(255, 252, 252, 252)
                            .withOpacity(0.3)
                        : const Color(0xFF6C63FF).withOpacity(0.08),
                    blurRadius: _isPressed ? 6 : 12,
                    offset: Offset(0, _isPressed ? 1 : 4),
                    spreadRadius: _isPressed ? 0 : 1,
                  ),
                  if (!isDark)
                    BoxShadow(
                      color: Colors.white.withOpacity(0.9),
                      blurRadius: 1,
                      offset: const Offset(0, -1),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              const Color.fromARGB(255, 255, 255, 255),
                              const Color.fromARGB(255, 255, 255, 255),
                            ]
                          : [
                              Colors.white,
                              const Color(0xFFFAFBFF),
                            ],
                    ),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          children: [
                            // Profile Section
                            Expanded(
                              child: Row(
                                children: [
                                  // Avatar with Status
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              _getRankColor(widget.rank)
                                                  .withOpacity(0.3),
                                              _getRankColor(widget.rank)
                                                  .withOpacity(0.1),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _getRankColor(widget.rank)
                                                  .withOpacity(0.3),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),

                                        // assets/avatar_default.jpg
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // border: Border.all(
                                            //   width: 2,
                                            // ),
                                          ),
                                          child: ClipOval(
                                            child: widget.avatarUrl != null
                                                ? Image.network(
                                                    widget.avatarUrl,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  (loadingProgress
                                                                          .expectedTotalBytes ??
                                                                      1)
                                                              : null,
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      print(
                                                          'Failed to load avatar: $error');
                                                      return Image.asset(
                                                        'assets/avatar_default.jpg',
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  )
                                                : Image.asset(
                                                    'assets/avatar_default.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 1,
                                        right: 1,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFFEF4444),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 1.5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: (isActive
                                                        ? const Color(
                                                            0xFF10B981)
                                                        : const Color(
                                                            0xFFEF4444))
                                                    .withOpacity(0.3),
                                                blurRadius: 3,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),

                                  // Name and Contact
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.name,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            letterSpacing: -0.3,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone_outlined,
                                              size: 12,
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.6),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              widget.phone,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: theme
                                                    .colorScheme.onSurface
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
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

                            // Rank Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getRankColor(
                                        getNameRankBasedPoint(widget.points)),
                                    _getRankColor(getNameRankBasedPoint(
                                            widget.points))
                                        .withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getRankColor(getNameRankBasedPoint(
                                            widget.points))
                                        .withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getRankIcon(widget.rank),
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    getNameRankBasedPoint(widget.points)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Metrics Row
                        Row(
                          children: [
                            Expanded(
                              child: _MetricCard(
                                icon: Icons.shopping_bag_outlined,
                                label: 'Orders',
                                value: widget.totalOrders.toString(),
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _MetricCard(
                                icon: Icons.payments_outlined,
                                label: 'Spent',
                                value: NumberFormat.compact(locale: 'en')
                                    .format(widget.totalSpending),
                                //   suffix: '\$',
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _MetricCard(
                                icon: Icons.stars_rounded,
                                label: 'Points',
                                value: NumberFormat.compact(locale: 'en')
                                    .format(widget.points),
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Footer Row
                        Row(
                          children: [
                            // Last Activity
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 12,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Activity: ${_formatTimeAgo(widget.lastOrderDate)}',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.7),
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Action Buttons
                            _ActionButton(
                              icon: Icons.phone_outlined,
                              onTap: widget.onCall,
                              color: const Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 6),
                            _ActionButton(
                              icon: Icons.chat_bubble_outline,
                              onTap: widget.onMessage,
                              color: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 6),
                            _StatusToggle(
                              isActive: isActive,
                              onToggle: widget.onToggleStatus,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? suffix;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffix != null)
                Text(
                  suffix!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.8),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
              fontSize: 9,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }
}

class _StatusToggle extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onToggle;

  const _StatusToggle({
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF10B981).withOpacity(0.1)
              : const Color(0xFFEF4444).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? const Color(0xFF10B981).withOpacity(0.3)
                : const Color(0xFFEF4444).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              isActive ? 'Active' : 'Blocked',
              style: TextStyle(
                color: isActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
