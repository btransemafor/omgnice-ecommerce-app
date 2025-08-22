import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';

class CardBestProduct extends StatelessWidget {
  final ProductCardModel product;

  const CardBestProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              product.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.priceS!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add to cart
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 0,
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          )
        ],
      ),
    );
  }
}
