import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/caterogy.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/category_block.dart';
import '../providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                'Categories',
                style: styleTextTitle,
              ),
            ),
           /*  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  //TODO:  Xử lý xem tất cả danh mục
                },
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: Color(0xFF699D3C),
                    fontSize: 16,
                  ),
                ),
              ),
            ), */
          ],
        ),

        // Sử dụng Consumer cho phần load category
        Consumer<CategoryProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.categories.isEmpty) {
              print("Categories list is empty!");
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("No categories available"),
              );
            }

            // Debug logging
            print("Rendering ${provider.categories.length} categories");

            return SizedBox(
              height: 40,
              width: double.infinity,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: provider.categories.length,
                itemBuilder: (context, index) {
                  final category = provider.categories[index];
                  final isSelected = provider.selectedIndex == index;
                  return CategoryBlock(
                    category: category,
                    index: index,
                    isSelected: isSelected,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
              ),
            );
          },
        ),
      ],
    );
  }
}
