import 'package:flutter/material.dart';
import 'card_best_product.dart'; // Import cái card bạn đã làm
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';

class HorizontalBestProductList extends StatelessWidget {
  final List<ProductCardModel> products;

  const HorizontalBestProductList({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320, // đủ cho card hiện hoàn chỉnh
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 220,
            child: CardBestProduct(product: products[index]),
          );
        },
      ),
    );
  }
}
