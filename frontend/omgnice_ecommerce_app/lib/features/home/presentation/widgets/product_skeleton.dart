import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm giả
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            // Tên sản phẩm giả
            Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 6),
            // Dòng mô tả giá giả
            Container(
              height: 12,
              width: 60,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
