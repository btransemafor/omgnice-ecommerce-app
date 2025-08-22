import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardStatsGrid extends StatelessWidget {
  final DashboardEntity dashboardData;

  const DashboardStatsGrid({super.key, required this.dashboardData});

  @override
  Widget build(BuildContext context) {
    // Format currency with M/K units
    String formatCurrency(double amount) {
      if (amount >= 1000000) {
        return '${(amount / 1000000).toStringAsFixed(1)}M';
      } else if (amount >= 1000) {
        return '${(amount / 1000).toStringAsFixed(1)}K';
      } else {
        return amount.toStringAsFixed(0);
      }
    }

    final cardHeight = 180.0;
    final totalHeight = (cardHeight * 3) + (16.0 * 2);

    // Subtle and elegant gradient card data
    final cardData = [
      {
        'title': 'Total Orders',
        'value': dashboardData.totalOrders.toString(),
        'icon': Icons.shopping_bag_outlined,
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B73FF), Color(0xFF8B92FF)],
        ),
        'accentColor': const Color(0xFF6B73FF),
      },
      {
        'title': 'Processing Orders',
        'value': dashboardData.processingOrders.toString(),
        'icon': Icons.schedule_outlined,
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 188, 9, 15),
            Color.fromARGB(255, 123, 33, 8)
          ],
        ),
        'accentColor': const Color(0xFFFF9A9E),
      },
      {
        'title': 'Completed Orders',
        'value': dashboardData.completedOrders.toString(),
        'icon': Icons.verified_outlined,
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 29, 49, 139),
            Color.fromARGB(255, 7, 19, 49)
          ],
        ),
        'accentColor': const Color(0xFF667eea),
      },
      {
        'title': 'Total Customers',
        'value': dashboardData.totalCustomers.toString(),
        'icon': Icons.groups_outlined,
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 25, 95, 36),
            Color.fromARGB(255, 8, 210, 116)
          ],
        ),
        'accentColor': const Color(0xFF7F7FD3),
      },
      {
        'title': 'Total Revenue',
        'value': formatCurrency(dashboardData.totalRevenue.toDouble()),
        'icon': Icons.trending_up_outlined,
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(255, 225, 32, 170), Color(0xFFFEF9D7)],
        ),
        'accentColor': const Color.fromARGB(255, 39, 6, 30),
      },
      {
        'title': 'Order Value',
        'value': formatCurrency(dashboardData.orderValueTotal.toDouble()),
        'icon': Icons.diamond_outlined,
        'gradient': const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 7, 27, 49),
            Color.fromARGB(255, 27, 109, 234)
          ],
        ),
        'accentColor': const Color(0xFFC3CEDA),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade50,
            Colors.white.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: totalHeight,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              mainAxisExtent: 180,
            ),
            itemCount: cardData.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return PremiumStatsCard(
                title: cardData[index]['title'] as String,
                value: cardData[index]['value'] as String,
                icon: cardData[index]['icon'] as IconData,
                gradient: cardData[index]['gradient'] as LinearGradient,
                accentColor: cardData[index]['accentColor'] as Color,
                index: index,
              );
            },
          ),
        ),
      ),
    );
  }
}

class PremiumStatsCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  final Color accentColor;
  final int index;

  const PremiumStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.accentColor,
    required this.index,
  });

  @override
  _PremiumStatsCardState createState() => _PremiumStatsCardState();
}

class _PremiumStatsCardState extends State<PremiumStatsCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _glowController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Slide in animation
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800 + (widget.index * 200)),
      vsync: this,
    );

    // Scale animation for hover
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
    });

    if (hovering) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: GestureDetector(
            onTap: () {
              // Pulse animation on tap
              _scaleController.forward().then((_) {
                _scaleController.reverse();
              });
            },
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      // Animated glow effect - more subtle
                      BoxShadow(
                        color: widget.accentColor
                            .withOpacity(_glowAnimation.value * 0.15),
                        blurRadius: 15 + (_glowAnimation.value * 5),
                        spreadRadius: _glowAnimation.value * 1,
                        offset: const Offset(0, 6),
                      ),
                      // Static shadow
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Gradient background
                        Container(
                          decoration: BoxDecoration(
                            gradient: widget.gradient,
                          ),
                        ),

                        // Glassmorphism overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),

                        // Animated shine effect
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 600),
                          top: _isHovered ? -100 : -200,
                          left: _isHovered ? -50 : -100,
                          child: Transform.rotate(
                            angle: 0.5,
                            child: Container(
                              width: 100,
                              height: 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 25, bottom: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon with backdrop blur
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  widget.icon,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(height: 2),

                              // Value and title
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Border highlight
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
