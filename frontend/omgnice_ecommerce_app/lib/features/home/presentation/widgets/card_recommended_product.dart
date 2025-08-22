// ignore_for_file: unnecessary_string_interpolations, unnecessary_cast, deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_dialog.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_view_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/provider/favorite_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_detail_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

class CardRecommendedProduct extends StatefulWidget {
  final bool gradient;
  final ProductCardModel product;

  const CardRecommendedProduct({
    super.key,
    required this.gradient,
    required this.product,
  });

  @override
  _CardRecommendedProductState createState() => _CardRecommendedProductState();
}

class _CardRecommendedProductState extends State<CardRecommendedProduct>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    final bool isMediumScreen =
        screenSize.width >= 360 && screenSize.width < 600;
    final bool isTablet = screenSize.width >= 600 && screenSize.width < 900;

    final double cardWidth = isSmallScreen
        ? screenSize.width * 0.85
        : isMediumScreen
            ? 280
            : isTablet
                ? 320
                : 350;

    final double cardHeight = isSmallScreen
        ? 380
        : isMediumScreen
            ? 400
            : isTablet
                ? 450
                : 480;

    final double titleFontSize = isSmallScreen
        ? 22
        : isMediumScreen
            ? 20
            : 32;
    final double priceFontSize = isSmallScreen
        ? 16
        : isMediumScreen
            ? 15
            : 20;
    final double buttonFontSize = isSmallScreen
        ? 14
        : isMediumScreen
            ? 14
            : 18;
    final double descFontSize = isSmallScreen
        ? 12
        : isMediumScreen
            ? 14
            : 16;

    final double mainPadding = isSmallScreen ? 12.0 : 16.0;
    final double spacerHeight = isSmallScreen ? 8.0 : 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double dynamicWidth = constraints.maxWidth > 0
            ? min(constraints.maxWidth, cardWidth)
            : cardWidth;

        return Container(
          height: cardHeight,
          width: dynamicWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Hero(
            tag: 'product_${widget.product.name}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image with zoom animation
                  TweenAnimationBuilder(
                    duration: const Duration(seconds: 20),
                    tween: Tween<double>(begin: 1.0, end: 1.05),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Image.network(
                          widget.product.imageUrl ??
                              'https://via.placeholder.com/150',
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.image_not_supported),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(mainPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row with badge and favorite
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Premium badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 12,
                                  vertical: isSmallScreen ? 4 : 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified,
                                      color: Colors.white,
                                      size: isSmallScreen ? 12 : 16),
                                  SizedBox(width: isSmallScreen ? 2 : 4),
                                  Text(
                                    'Premium',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isSmallScreen ? 10 : 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Favorite button with animation
                            Consumer<FavoriteProvider>(
                              builder: (context, favPro, child) {
                                return GestureDetector(
                                  behavior: HitTestBehavior
                                      .translucent, // Ensures only child area is tappable
                                  onTap: () async {
                                    try {
                                      await favPro.addFavoriteProduct(
                                          widget.product.id!);
                                      bool success = favPro.isSuccess;

                                     await favPro.fetchFavoriteProducts();
                                      _controller.forward();

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1000), () {
                                            Navigator.of(context).pop();
                                          });

                                          return CustomDialog(
                                            content: success
                                                ? 'Added to Favorites!'
                                                : 'Already in Favorites!',
                                            icon: success
                                                ? Icons.favorite
                                                : Icons.info,
                                            iconColor: success
                                                ? Colors.redAccent
                                                : Colors.amber,
                                          );
                                        },
                                      );
                                    } catch (error) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1500), () {
                                            Navigator.of(context).pop();
                                          });

                                          return CustomDialog(
                                            content:
                                                'Oops! Something went wrong.',
                                            icon: Icons.error,
                                            iconColor: Colors.red,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          isSmallScreen ? 8 : 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        favPro.isFavorite(widget.product.id!)
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: favPro
                                                .isFavorite(widget.product.id!)
                                            ? Colors.redAccent
                                            : Colors.white,
                                        size: isSmallScreen ? 24 : 30,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Rating stars
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 8 : 12,
                                vertical: isSmallScreen ? 2 : 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                SizedBox(width: isSmallScreen ? 2 : 4),
                                Text(
                                  '${widget.product.starReview}',
                                  style: GoogleFonts.poppins(
                                    fontSize: isSmallScreen ? 12 : 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: spacerHeight),

                        // Product name with shadow
                        Container(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Text(
                                widget.product.name,
                                style: GoogleFonts.poppins(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.4),
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                widget.product.name,
                                style: GoogleFonts.poppins(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.1,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 2 : 4),

                        // Product description
                        Text(
                          'Premium Quality',
                          style: GoogleFonts.poppins(
                            fontSize: descFontSize,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: spacerHeight),

                        // Price and Add to Cart button
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 12,
                                  vertical: isSmallScreen ? 6 : 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                    size: isSmallScreen ? 16 : 20,
                                  ),
                                  SizedBox(width: isSmallScreen ? 2 : 4),
                                  Text(
                                    FormatCurrency.formatCurrency(
                                        widget.product.priceS as double),
                                    style: GoogleFonts.poppins(
                                      fontSize: priceFontSize,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 6 : 8),
                            Expanded(
                              child: _buildAddToCartButton(
                                  buttonFontSize, isSmallScreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Shimmer loading effect
                  FutureBuilder(
                    future: precacheImage(
                        NetworkImage(widget.product.imageUrl ??
                            'https://via.placeholder.com/150'),
                        context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return const SizedBox.shrink();
                      }
                      return _buildShimmerEffect();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddToCartButton(double fontSize, bool isSmallScreen) {
    return ElevatedButton(
      onPressed: () async{
         // Get providers
                      final productDetailProvider =
                          Provider.of<ProductDetailProvider>(context,
                              listen: false);
                      final productProvider =
                          Provider.of<ProductProvider>(context, listen: false);
                      final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);

                      // Get values for cart item
                    //  final quantity = productProvider.quantity;
                      /* final productSize = productProvider.selectedSize ?? '';
                      final price = productProvider.selectedPrice;
                      final note = productDetailProvider.noteForOrder; */
                    
                    productProvider.chooseSize('S'); 
                    productProvider.getPrice(productProvider.selectedSize!); 
                    final productSize = productProvider.selectedSize ?? '';
                    final price = productProvider.selectedPrice;

                      // Create cart item
                      final cartItem = CartItemViewModel(
                        cartItemModel: CartItemModel(
                          cartItemId: null,
                          nameProduct: widget.product.name ?? '',
                          productId: widget.product.id ?? 0,
                          variantId: 0, // TODO: Get actual variant ID if needed
                          imageProduct: widget.product.imageUrl ?? '',
                          variantName: 'S',
                          price: null,
                          discountPrice: price?.toDouble(),
                          quantity: 1,
                          note: '',
                        ),
                        imageUrl: widget.product.imageUrl ?? '',
                        productName: widget.product.name ?? '',
                      );

                      // Add to cart
                      final success = await cartProvider.addToCart(cartItem);
                      if (success) {
                        SuccessHelper.showSuccess(
                            context, 'Added to cart successfully!');
                      } else {
                        ErrorHelper.showError(
                            context, 'Failed to add to cart. Try again!');
                      }
                    },
    
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade500,
        foregroundColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.green.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart,
            size: isSmallScreen ? 14 : 18,
            color: Colors.white,
          ),
          SizedBox(width: isSmallScreen ? 4 : 8),
          Text(
            'Add to Cart',
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.withOpacity(0.3),
            Colors.grey.withOpacity(0.1),
            Colors.grey.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}

extension BackdropDecoration on BoxDecoration {
  BoxDecoration get backdrop {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      gradient: gradient,
    );
  }
}
