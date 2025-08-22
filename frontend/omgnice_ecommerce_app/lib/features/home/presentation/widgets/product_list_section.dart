import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/card_product.dart';
import './product_skeleton.dart';
import 'package:provider/provider.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("🟢 ProductListSection build lại!");

    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) => const ProductSkeleton(),
            ),
          );
        }

        if (provider.products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(5),
            child: ProductSkeleton(), 
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 35, left: 12, right: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return CardProduct(product: product);
            },
          ),
        );
      },
    );
  }
}
