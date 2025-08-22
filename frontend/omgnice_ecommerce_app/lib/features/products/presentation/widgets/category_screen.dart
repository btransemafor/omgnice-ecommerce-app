import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/category_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi provider để load dữ liệu khi mở màn
    Future.microtask(() =>
        context.read<CategoryProvider>().fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          return ListTile(
            title: Text(category.name), // đổi thành tên field bạn có
            subtitle: Text("ID: ${category.id}"),
          );
        },
      ),
    );
  }
}
