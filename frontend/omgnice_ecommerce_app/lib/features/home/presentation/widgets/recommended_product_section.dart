import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart';
import 'package:omgnice_ecommerce_app/core/widgets/shimmer_widget.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/widgets/card_recommended_product.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/pages/product_detail_loading.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

class RecommendedProductSection extends StatelessWidget {
  RecommendedProductSection({super.key});
  // Define mockProducts here
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 30),
          child: Text(
            'Recommended For You',
            style: styleTextTitle,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            final recommended = productProvider.recommendProducts;
            print("📦 Đang render ${recommended.length} sản phẩm recommended");

            if (recommended.isEmpty) {
              return SizedBox(
                  height: 420,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShimmerWidget.rectangular(
                          height: 420,
                          width: 250,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShimmerWidget.rectangular(
                          height: 420,
                          width: 250,
                        ),
                      )
                    ],
                  ));
            }

            return SizedBox(
              height: 420,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommended.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = recommended[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetailLoadingScreen(
                              productId: item.id ?? 0,
                            ),
                          ),
                        );
                      },
                      child: CardRecommendedProduct(
                        product: ProductCardModel(
                            id: item.id,
                            priceS: item.priceS,
                            name: item.name,
                            soldQuantity: item.soldQuantity,
                            imageUrl: item.imageUrl,
                            categoryId: item.categoryId,
                            discountPercent: item.discountPercent,
                            isHidden: item.isHidden,
                            starReview: item.starReview),
                        gradient: true,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
