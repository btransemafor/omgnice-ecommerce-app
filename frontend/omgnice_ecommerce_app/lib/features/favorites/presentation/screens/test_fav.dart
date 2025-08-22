import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_dialog.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_entity.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/pages/product_detail_loading.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/provider/favorite_provider.dart';

class TestFav extends StatefulWidget {
  const TestFav({super.key});

  @override
  State<TestFav> createState() => _TestFavState();
}

class _TestFavState extends State<TestFav> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Fetch data after frame is built
    Future.microtask(() async {
      final provider = Provider.of<FavoriteProvider>(context, listen: false);
      await provider.fetchFavoriteProducts();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: BeautifulAppBar(
        title: 'Your Favorite Product',
        gradient: true,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, fav, child) {
          if (_isLoading) {
            return const Center(
              child: CustomLoading(),
            );
          }

          if (fav.userFavorite.isEmpty) {
            return _buildEmptyState();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: ListView.separated(
              itemCount: fav.userFavorite.length,
              itemBuilder: (context, index) {
                final item = fav.userFavorite[index];
                return _buildProductCard(item, context);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 40),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductEntity product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailLoadingScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Discount Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Hero(
                    tag: 'product_image_${product.id}',
                    child: Image.network(
                      product.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 130,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 130,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (product.discount_percent > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${product.discount_percent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                      onPressed: () async {
                        // Implement remove from favorites
                        final provider = Provider.of<FavoriteProvider>(context,
                            listen: false);
                        showCustomDialog(
                          context: context,
                          content:
                              'Are you sure you want to remove this item from favorites?',
                          // title: 'Are you sure ?',
                          cancelText: 'Cancel',
                          onConfirm: () async {
                            // Add your async logic here
                            await provider.deleteFavoriteProducts(product.id);
                          },
                        );

                        final isSuccess = provider.isSuccess;

                        if (isSuccess) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 1));
                                Navigator.of(context).pop();
                                return CustomDialog(
                                    content: 'Đã xóa khỏi mục yêu thích');
                              });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF303030),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sold ${product.soldQuantity}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                /*   if (product.stockQuantity < 10)
                    Text(
                      'Còn ${product.stockQuantity} sản phẩm',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildEmptyState() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated heart icon with gradient background
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink.shade100,
                Colors.red.shade50,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.1),
                spreadRadius: 8,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.favorite_border_rounded,
            size: 60,
            color: Colors.red.shade400,
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Main title with gradient text effect
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.grey.shade700, Colors.grey.shade500],
          ).createShader(bounds),
          child: const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        Text(
          'Discover amazing products and add them\nto your favorites collection',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            height: 1.5,
            letterSpacing: 0.2,
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Modern action button with gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color.fromARGB(255, 29, 205, 52),
                const Color.fromARGB(255, 4, 75, 16),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Provider.of<ScreenManager>(context, listen: false).goToHome();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.explore_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Explore Products',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Additional helpful text
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tip: Tap the heart icon on ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // any product to save it here 

              const Text(
                'any product to save it here',
                style: TextStyle(
                  fontSize: 12,
                 color: Color.fromARGB(255, 117, 117, 117),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
