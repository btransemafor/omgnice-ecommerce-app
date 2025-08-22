import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/category_provider.dart';
import 'package:provider/provider.dart';

import '../../domains/entities/caterogy.dart';
import '../providers/product_provider.dart';

class CategoryBlock extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final bool isSelected;

  const CategoryBlock({
    Key? key,
    required this.category,
    required this.index,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return GestureDetector(
      onTap: () {
        final categoryId = category.id;

        //  Chỉ gọi API nếu category khác với category hiện tại
        if (categoryProvider.selectedIndex != index) {
          categoryProvider.selectCategory(index);
          context.read<ProductProvider>().getProductsByCategory(categoryId);
          print("Đã chọn Category: $categoryId");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(
            color: const Color(0xFF699D3C), // Màu viền
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            category.name,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : const Color(0xFF699D3C),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}