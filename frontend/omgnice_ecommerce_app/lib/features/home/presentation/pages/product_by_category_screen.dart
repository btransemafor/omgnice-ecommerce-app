import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/card_product.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/promotion_countdown.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/reset_countdown_widget.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  final int categoryId;
  final String? categoryName;
  final String? bannerImage;

  const ProductListScreen({
    Key? key,
    required this.categoryId,
    this.categoryName,
    this.bannerImage,
  }) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  final endTime =
      DateTime.now().add(const Duration(days: 2, hours: 5, minutes: 30));

  String _sortBy = 'popular';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();

    // Animation controllers
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);

    // Fetch products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.getProductsByCategory(widget.categoryId);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Stunning App Bar with Hero Effect
            SliverAppBar(
              expandedHeight: 190,
              //   floating: true,
              //  pinned: true,
              pinned: false, // Quan trọng: cho phép cuộn lên hết
              floating: false, // Không cho SliverAppBar "bay lên"
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 1, 23, 8)),
                  child: Stack(
                    children: [
                      // Animated Background Pattern - FIXED
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  // Added background color for blend mode to work
                                  color: Colors.amber.withOpacity(0.3),
                                  backgroundBlendMode: BlendMode.overlay,
                                  /*  image: DecorationImage(
                                    image: AssetImage('assets/pattern.png'), // Add a subtle pattern
                                    fit: BoxFit.cover,
                                    opacity: 0.1,
                                  ), */
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Floating Elements
                      Positioned(
                        top: 100,
                        right: 30,
                        child: AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: Opacity(
                                opacity: _fadeAnimation.value,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.local_fire_department,
                                          color: Colors.orange.shade200,
                                          size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'HOT DEALS',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Main Content
                      Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: Opacity(
                                opacity: _fadeAnimation.value,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow.shade400,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        '🔥 FLASH SALE',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      widget.categoryName ?? 'Amazing Products',
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 2),
                                              blurRadius: 4),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Exclusive deals just for you! ✨',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: // Filter and Sort Section
                  SizedBox(
                height: 250,
                child: PromotionalCountdown(
                  endTime: endTime,
                  title: "MEGA SALE",
                  style: CountdownStyle.gradient,
                  primaryColor: const Color(0xFF6A1B9A),
                  accentColor: const Color(0xFFE91E63),
                ),
              ),
            ),

            // Gradient Style

            // Products Grid
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.shade100,
                                    Colors.pink.shade100
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.purple.shade400),
                                strokeWidth: 3,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Loading amazing deals...',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (provider.products.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey.shade100,
                                    Colors.grey.shade200
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Oops! No products found',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'But don\'t worry, more amazing deals are coming soon!',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = provider.products[index];
                        return AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0,
                                  _slideAnimation.value * (1 - (index * 0.1))),
                              child: Opacity(
                                opacity: _fadeAnimation.value,
                                child: EnhancedCardProduct(
                                  product: product,
                                  index: index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: provider.products.length,
                    ),
                  ),
                );
              },
            ),

            // Bottom Spacing
            SliverToBoxAdapter(
              child: // Filter and Sort Section
                  SizedBox(
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced Product Card Widget
class EnhancedCardProduct extends StatefulWidget {
  final dynamic product;
  final int index;

  const EnhancedCardProduct({
    Key? key,
    required this.product,
    required this.index,
  }) : super(key: key);

  @override
  _EnhancedCardProductState createState() => _EnhancedCardProductState();
}

class _EnhancedCardProductState extends State<EnhancedCardProduct>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );

    _shadowAnimation = Tween<double>(begin: 5.0, end: 20.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: _shadowAnimation.value,
                    offset: Offset(0, _shadowAnimation.value / 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                    ),
                  ),
                  child: Stack(
                    clipBehavior:
                        Clip.none, // Cho phép các widget con vượt ra ngoài
                    children: [
                      // Your original CardProduct content goes here
                      CardProduct(product: widget.product),

                      // Overlay effects
                      Positioned(
                        top: 1,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade400,
                                Colors.pink.shade400
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'HOT!!!',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Quick action button
                      if (_isHovered)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade400,
                                  Colors.pink.shade400
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
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
