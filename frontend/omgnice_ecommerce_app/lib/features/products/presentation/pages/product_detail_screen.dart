import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_view_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_detail_entity.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_detail_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/product_review_list.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/quantity_button.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/modal_note_order.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/product_detail_header.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/size_selector.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:omgnice_ecommerce_app/features/reviews/presentation/provider/review_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Định nghĩa bảng màu hiện đại cho app
class AppColors {
  static const Color primary = Color(0xFF3D5AFE);
  static const Color secondary = Color(0xFF00C853);
  static const Color accent = Color(0xFFFF3D00);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color priceColor = Color(0xFFE53935);
  static const Color buttonColor = const Color.fromARGB(255, 5, 104, 1);
}

class ProductDetailScreen extends StatefulWidget {
  final ProductDetailEntity product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Mapping for variant sizes
  final Map<String, String> variantMapping = {
    'Small': 'S',
    'Medium': 'M',
    'Large': 'L'
  };

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.product.variants != null &&
          widget.product.variants!.isNotEmpty) {
        final productProvider =
            Provider.of<ProductProvider>(context, listen: false);
      }
    });
  }

  // Format price method
  String formattedPrice(int price) {
    final formatter = NumberFormat('#,###', 'vi');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Header
              Stack(
                children: [
                  ProductDetailHeader(
                    product_id: widget.product.id ?? 0,
                    size: size,
                    urlImage: widget.product.imageUrl ?? '',
                    imageType: ImageType.network,
                  ),
                ],
              ),

              // Product Details Card
              Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 20, bottom: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name with Category
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Share button
                        IconButton(
                          icon: const Icon(Icons.share_outlined,
                              color: AppColors.textSecondary),
                          onPressed: () {
                            // Handle share functionality
                          },
                        ),
                      ],
                    ),

                    // Brand info if available

                    const SizedBox(height: 16),

                    // Price and Rating Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price with Consumer to update when selected size changes
                        Consumer<ProductProvider>(
                            builder: (context, provider, _) {
                          // Get price of the selected size
                          final String? selectedSize = provider.selectedSize;
                          double priceSelected = 0.0;

                          if (selectedSize != null) {
                            priceSelected =
                                provider.getPrice(selectedSize) ?? 0.0;
                          }

                          return Text(
                            '${formattedPrice(int.parse(priceSelected.toStringAsFixed(0)))} đ',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.priceColor,
                            ),
                          );
                        }),

                        // Ratings and Sold Count
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                widget.product.ratingStar?.toString() ?? "0.0",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${widget.product.soldQuantity ?? 0})',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Size Selector Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Size title with custom badge
                    Row(
                      children: [
                        Text(
                          'Choose Size',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Required',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Size Selector with Null Safety
                    if (widget.product.variants != null &&
                        widget.product.variants!.length >= 3)
                      SizeSelector(
                        priceS:
                            Provider.of<ProductProvider>(context, listen: false)
                                    .getPrice('S') ??
                                0.0,
                        priceM:
                            Provider.of<ProductProvider>(context, listen: false)
                                    .getPrice('M') ??
                                0.0,
                        priceL:
                            Provider.of<ProductProvider>(context, listen: false)
                                    .getPrice('L') ??
                                0.0,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Size options not available'),
                      ),
                  ],
                ),
              ),

              // Customize Order Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize Your Order',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Note Order Button and Quantity Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const ModalNoteOrder(),
                              );
                            },
                            icon: const Icon(Icons.edit_note_outlined,
                                color: Colors.white),
                            label: Text(
                              'Add Note',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Quantity Control
                        Consumer<ProductProvider>(
                          builder: (context, provider, _) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              //  border: Border.all(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: QuantityButton(
                              quantity: provider.quantity,
                              onAdd: provider.increaseQuantity,
                              onRemove: provider.decreaseQuantity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Product Details Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Product Details',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Icon(
                          Icons.info_outline,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Feature Icons
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildFeatureItem(size,
                              'assets/icon-static-detail/energy.png', 'Energy'),
                          buildFeatureItem(
                              size,
                              'assets/icon-static-detail/fast-delivery.png',
                              'Fast'),
                          buildFeatureItem(
                              size,
                              'assets/icon-static-detail/icon-delicious.jpg',
                              'Taste'),
                          buildFeatureItem(size,
                              'assets/icon-static-detail/safe.jpg', 'Safe'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Product Description
                    ExpandableText(
                      widget.product.description ?? '',
                      expandText: 'Read more',
                      collapseText: 'Read less',
                      maxLines: 3,
                      linkColor: AppColors.primary,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                      prefixText: 'Description: ',
                      prefixStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      animationDuration: const Duration(milliseconds: 200),
                      animation: true,
                    )
                  ],
                ),
              ),

              // Reviews Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer Reviews',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // View all reviews
                          },
                          child: Text(
                            'View All',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Display product reviews using Consumer
                    Consumer<ReviewProvider>(
                      builder: (context, reviewProvider, _) {
                        return ProductReviewList(
                          reviews: reviewProvider.reviews,
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bottom spacing to ensure we can scroll past the bottom sheet
              const SizedBox(height: 100),
            ],
          ),
        ),

        // Bottom Sheet with Total and Add to Cart Button
        bottomSheet: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Price
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Payable",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Consumer<ProductProvider>(
                      builder: (context, provider, _) => Text(
                            '${formattedPrice(int.parse(provider.total.toStringAsFixed(0)))} đ',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.priceColor,
                            ),
                          )),
                ],
              ),

              // Add to Cart Button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Get providers
                      final productDetailProvider =
                          Provider.of<ProductDetailProvider>(context,
                              listen: false);
                      final productProvider =
                          Provider.of<ProductProvider>(context, listen: false);
                      final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);

                      // Get values for cart item
                      final quantity = productProvider.quantity;
                      final productSize = productProvider.selectedSize ?? '';
                      final price = productProvider.selectedPrice;
                      final note = productDetailProvider.noteForOrder;

                      // Create cart item
                      final cartItem = CartItemViewModel(
                        cartItemModel: CartItemModel(
                          cartItemId: null,
                          nameProduct: widget.product.name ?? '',
                          productId: widget.product.id ?? 0,
                          variantId: 0, // TODO: Get actual variant ID if needed
                          imageProduct: widget.product.imageUrl ?? '',
                          variantName: productSize,
                          price: null,
                          discountPrice: price?.toDouble(),
                          quantity: quantity,
                          note: note ?? '',
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
                      backgroundColor: const Color.fromARGB(255, 5, 104, 1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildFeatureItem(Size size, String assetPath, String label) {
    return Column(
      children: [
        Container(
          height: size.width * 1 / 9,
          width: size.width * 1 / 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: ClipOval(
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
