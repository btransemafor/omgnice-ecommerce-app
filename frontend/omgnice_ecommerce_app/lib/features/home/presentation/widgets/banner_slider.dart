import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:omgnice_ecommerce_app/core/widgets/shimmer_widget.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/entities/banner_entity.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/pages/lucky_page.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/pages/product_detail_loading.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/promotion_countdown.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerEntity> banners;
  const BannerSlider({Key? key, required this.banners}) : super(key: key);

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _indicatorController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Main Banner Carousel
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CarouselSlider(
                items: widget.banners.asMap().entries.map((entry) {
                  final index = entry.key;
                  final banner = entry.value;

                  return AnimatedBuilder(
                    animation: _slideController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (_slideController.value * 0.2),
                        child: _buildBannerItem(banner, index, isTablet),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  viewportFraction: isTablet ? 0.8 : 0.99,
                  enableInfiniteScroll: widget.banners.length > 1,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                  autoPlayCurve: Curves.easeInOutCubic,
                  autoPlayInterval: const Duration(seconds: 4),
                  height: isTablet ? 200 : 180,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                    _indicatorController.reset();
                    _indicatorController.forward();
                  },
                ),
              ),
            ),
          ),

          // Enhanced Indicators
          const SizedBox(height: 16.0),
          _buildEnhancedIndicators(),
        ],
      ),
    );
  }

  Widget _buildBannerItem(BannerEntity banner, int index, bool isTablet) {
    return GestureDetector(
      onTap: () => _handleBannerTap(banner),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Main Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  banner.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildLoadingShimmer(isTablet);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildErrorPlaceholder();
                  },
                ),
              ),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),

            // Premium Border Effect
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
            ),

            // Tap Indicator
            if (_currentIndex == index)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.touch_app,
                    size: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: Center(
        child: ShimmerWidget.rectangular(
          height: isTablet ? 200 : 180,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[200]!,
            Colors.grey[300]!,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: Colors.grey[500],
          ),
          const SizedBox(height: 8),
          Text(
            'Không thể tải ảnh',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedIndicators() {
    if (widget.banners.length <= 1) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _indicatorController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.banners.asMap().entries.map((entry) {
              final index = entry.key;
              final isActive = _currentIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                width: isActive ? 24.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                      ? const Color(0xFF2E7D32) // Rich green
                      : Colors.grey.shade300,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: isActive
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4CAF50),
                              Color(0xFF2E7D32),
                            ],
                          ),
                        ),
                      )
                    : null,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _handleBannerTap(BannerEntity banner) {
    // Haptic feedback for premium feel
    // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback

    if (banner.productId != null) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              //   EcommerceLuckyWheel()
              //
              ProductDetailLoadingScreen(
            productId: banner.productId ?? 0,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else if (banner.categoryId != null) {
      context.pushNamed(
        'productCategory',
        extra: banner.categoryId,
      );
    } else {
      //_showStylishSnackBar();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EcommerceLuckyWheel()),
      );
    }
  }

  void _showStylishSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Không có thông tin điều hướng',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
