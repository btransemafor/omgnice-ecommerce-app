import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_dialog.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/provider/favorite_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/pages/product_detail_loading.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/save_discount_card.dart';
import 'package:provider/provider.dart';

class CardProduct extends StatelessWidget {
  final ProductCardModel product;

  const CardProduct({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          final int productId = product.id!;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailLoadingScreen(productId: productId),
            ),
          );
        },
        child: Stack(
          children: [
            _belowCard(product),
            Positioned(
              top: 0,
              left: 0,
              child: SaveDiscountCard(
                product: product,
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 207, 206, 206).withOpacity(0.5)),
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favPro, child) {
                      return GestureDetector(
                        behavior: HitTestBehavior
                            .translucent, // Ensures only child area is tappable
                        onTap: () async {
                          try {
                            await favPro.addFavoriteProduct(product.id!);
                            bool success = favPro.isSuccess;

                              await favPro.fetchFavoriteProducts();

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.of(context).pop();
                                });

                                return CustomDialog(
                                  content: success
                                      ? 'Added to your favorites!'
                                      : 'This product is already in your favorites.',
                                  icon: success
                                      ? Icons.check_circle
                                      : Icons.info_outline,
                                  iconColor:
                                      success ? Colors.green : Colors.orange,
                                );
                              },
                            );
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });

                                return CustomDialog(
                                  content:
                                      'Something went wrong. Please try again.',
                                  icon: Icons.error_outline,
                                  iconColor: Colors.red,
                                );
                              },
                            );
                          }
                        },
                        child: Icon(
                                        favPro.isFavorite(product.id!)
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: favPro
                                                .isFavorite(product.id!)
                                            ? const Color.fromARGB(255, 202, 28, 28)
                                            : Colors.white,
                                      ),
                      );
                    },
                  ),
                ))
          ],
        ));
  }
}

Widget _belowCard(ProductCardModel product) {
  return Container(
    width: 180,
    height: 300,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        )
      ],
    ),
    padding: const EdgeInsets.all(7),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          flex: 2,
          child: Text( 
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${FormatCurrency.formatCurrency(product.priceS!.toInt())}',
            // Nên sử dụng
            // '${FormatCurrency.formatCurrency(int.tryParse(product.priceS.toString()) ?? 0)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${product.starReview}',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ],
            ),
            Text(
              'Sold: ${product.soldQuantity}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: const Icon(
                Icons.shopping_bag,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
