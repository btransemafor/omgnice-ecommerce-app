import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_dialog.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/provider/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProductDetailHeader extends StatefulWidget {
  final Size size;
  final String urlImage;
  final ImageType imageType;
  final int product_id;

  const ProductDetailHeader({
    Key? key,
    required this.size,
    required this.urlImage,
    required this.imageType,
    required this.product_id,
  }) : super(key: key);

  @override
  _ProductDetailHeaderState createState() => _ProductDetailHeaderState();
}

class _ProductDetailHeaderState extends State<ProductDetailHeader> with SingleTickerProviderStateMixin {
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
    return Container(
      height: widget.size.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.5)
                : Colors.blueAccent.withOpacity(0.2),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Parallax Background Image
          _buildParallaxImage(context),
          // Glassmorphism Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Back Button
          Positioned(
            left: 20,
            top: 40,
            child: _buildIconButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.pop(context),
              label: 'Back',
            ),
          ),
          // Action Buttons (Favorite & Cart)
          Positioned(
            right: 20,
            top: 40,
            child: Row(
              children: [
                Consumer<FavoriteProvider>(
                  builder: (context, favPro, child) {
                    return _buildFavoriteButton(context, favPro);
                  },
                ),
                const SizedBox(width: 16),
                _buildCartButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParallaxImage(BuildContext context) {
    return Hero(
      tag: 'product_image_${widget.product_id}',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _controller.value * 10), // Parallax effect
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              child: Container(
                width: double.infinity,
                height: widget.size.height * 0.38,
                child: _getImageWidget(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getImageWidget() {
    switch (widget.imageType) {
      case ImageType.network:
        return Image.network(
          widget.urlImage,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.white,
                strokeWidth: 3,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
        );
      case ImageType.asset:
        return Image.asset(
          widget.urlImage,
          fit: BoxFit.cover,
        );
      case ImageType.file:
        return Image.file(
          File(widget.urlImage),
          fit: BoxFit.cover,
        );
      default:
        return _buildErrorImage();
    }
  }

  Widget _buildErrorImage() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.broken_image,
        size: 60,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[400]
            : Colors.grey[600],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTap: onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Semantics(
            label: label,
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, FavoriteProvider favPro) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTap: () async {
        try {
          await favPro.addFavoriteProduct(widget.product_id);
          await favPro.fetchFavoriteProducts();
          bool success = favPro.isSuccess;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              Future.delayed(const Duration(milliseconds: 1500), () {
                Navigator.of(context).pop();
              });

              return CustomDialog(
                content: success
                    ? 'Added to Favorites!'
                    : 'Already in Favorites!',
                icon: success ? Icons.favorite : Icons.info,
                iconColor: success ? Colors.redAccent : Colors.amber,
              );
            },
          );
        } catch (error) {
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(milliseconds: 1500), () {
                Navigator.of(context).pop();
              });

              return CustomDialog(
                content: 'Oops! Something went wrong.',
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Semantics(
            label: 'Toggle Favorite',
            child: Icon(
              favPro.isFavorite(widget.product_id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: favPro.isFavorite(widget.product_id)
                  ? Colors.redAccent
                  : Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(),
                settings: const RouteSettings(name: '/ProductDetailScreen'),
              ),
            );
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return cartProvider.quantityItemCart > 0
                ? AnimatedScale(
                    scale: cartProvider.quantityItemCart > 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        '${cartProvider.quantityItemCart}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }
}

enum ImageType {
  network,
  asset,
  file,
}