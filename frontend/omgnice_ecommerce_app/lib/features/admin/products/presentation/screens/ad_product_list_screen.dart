import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/provider/admin_product_provider.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/screens/edit_product_screen.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int? selectedCategoryId;
  String searchQuery = '';
  bool isSearching = false;
  bool isGridView = true;
  final TextEditingController _searchController = TextEditingController();

  final SliverGridDelegateWithFixedCrossAxisCount gridDelegate =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 0.75,
  );

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false); // Add RefreshController

  @override
  void initState() {
    super.initState();
    debugPrint('ProductListScreen initState called');
    Future.microtask(() async {
      final adProductProvider =
          Provider.of<AdminProductProvider>(context, listen: false);
      await adProductProvider.fetchListProduct();
      if (adProductProvider.listProduct.isNotEmpty) {
        debugPrint(
            'First product variants: ${adProductProvider.listProduct[0].variants}');
      } else {
        debugPrint('listProduct is empty after fetch');
      }
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      await categoryProvider.fetchCategories();
    });
  }

  // Hàm xử lý làm mới danh sách
  Future<void> _onRefresh() async {
    try {
      await Provider.of<AdminProductProvider>(context, listen: false)
          .fetchListProduct();
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      await categoryProvider.fetchCategories();
      _refreshController.refreshCompleted(); // Xác nhận làm mới thành công
    } catch (e) {
      _refreshController.refreshFailed(); // Xác nhận làm mới thất bại
      _showSnackBar('Error refreshing user list: $e', Colors.red);
    }
  }

  // Hàm hiển thị SnackBar
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        header: WaterDropHeader(
          waterDropColor: const Color(0xFF26A69A), // Teal accent
          complete: Icon(
            Icons.check,
            color: const Color(0xFF26A69A),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: isSearching
                ? TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search Product ...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      final adProductProvider =
                          Provider.of<AdminProductProvider>(context,
                              listen: false);
                      adProductProvider.searchProducts(value);
                    },
                  )
                : Text(
                    'List Product',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
            centerTitle: false,
            backgroundColor: Colors.green[700],
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      if (!isSearching) {
                        _searchController.clear();
                        searchQuery = '';
                        final adProductProvider =
                            Provider.of<AdminProductProvider>(context,
                                listen: false);
                        adProductProvider.resetSearch();
                      }
                    });
                  },
                  icon: Icon(
                    isSearching ? Icons.close : Icons.search_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isGridView ? Icons.view_list : Icons.grid_view,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isGridView = !isGridView;
                  });
                },
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF5F7FA),
                  Color(0xFFE4E9F2),
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Consumer<CategoryProvider>(
                          builder: (context, categoryProvider, child) {
                            if (categoryProvider.isLoading) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 3, 164, 22)));
                            }
                            if (categoryProvider.error != null) {
                              return Center(
                                child: Text(
                                  categoryProvider.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            final categories = categoryProvider.categories;
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: const Text('All'),
                                    selected: selectedCategoryId == null,
                                    onSelected: (_) {
                                      setState(() {
                                        selectedCategoryId = null;
                                      });
                                      final adProductProvider =
                                          Provider.of<AdminProductProvider>(
                                              context,
                                              listen: false);
                                      adProductProvider.resetFilter();
                                    },
                                    backgroundColor: Colors.white,
                                    selectedColor:
                                        const Color.fromARGB(255, 3, 164, 22),
                                    checkmarkColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: selectedCategoryId == null
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: selectedCategoryId == null
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: selectedCategoryId == null
                                            ? Colors.transparent
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                ),
                                ...categories.map((category) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(category.name),
                                      selected:
                                          selectedCategoryId == category.id,
                                      onSelected: (_) {
                                        setState(() {
                                          selectedCategoryId = category.id;
                                        });
                                        final adProductProvider =
                                            Provider.of<AdminProductProvider>(
                                                context,
                                                listen: false);
                                        adProductProvider
                                            .filterProduct(category.id);
                                      },
                                      backgroundColor: Colors.white,
                                      selectedColor:
                                          const Color.fromARGB(255, 3, 164, 22),
                                      checkmarkColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: selectedCategoryId == category.id
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight:
                                            selectedCategoryId == category.id
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color:
                                              selectedCategoryId == category.id
                                                  ? Colors.transparent
                                                  : Colors.grey.shade300,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<AdminProductProvider>(
                    builder: (context, provider, child) {
                      debugPrint(
                          'displayProducts variants: ${provider.filterProducts.isNotEmpty ? provider.filterProducts.map((p) => p.variants).toList() : provider.listProduct.map((p) => p.variants).toList()}');
                      if (provider.isLoading) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF1A237E)));
                      }
                      final displayProducts = provider.filterProducts.isNotEmpty
                          ? provider.filterProducts
                          : provider.listProduct;
                      if (displayProducts.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search_off,
                                  size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                'No product found',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return isGridView
                          ? GridView.builder(
                              padding: const EdgeInsets.all(10.0),
                              gridDelegate: gridDelegate,
                              itemCount: displayProducts.length,
                              itemBuilder: (context, index) {
                                final product = displayProducts[index];
                                return _buildProductCard(
                                    context, product, provider);
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: displayProducts.length,
                              itemBuilder: (context, index) {
                                final product = displayProducts[index];
                                return _buildProductListItem(
                                    context, product, provider);
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.pushNamed('createProductScreen');
            },
            backgroundColor: const Color.fromARGB(255, 239, 239, 239),
            tooltip: 'Create New Product',
            child: const Icon(Icons.add, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ));
  }

  Widget _buildProductCard(
      BuildContext context, Product product, AdminProductProvider provider) {
    debugPrint('ProductCard variants: ${product.variants}');
    return GestureDetector(
      onTap: () {
        debugPrint(
            'Navigating from ProductCard with variants: ${product.variants}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProductScreen(product: product),
          ),
        ).then((updatedProduct) {
          if (updatedProduct != null) {
            // provider.updateProduct(updatedProduct);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      height: 120,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 10, 14, 51),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(
      BuildContext context, Product product, AdminProductProvider provider) {
    debugPrint('ProductListItem variants: ${product.variants}');
    return GestureDetector(
      onTap: () {
        debugPrint(
            'Navigating from ProductListItem with variants: ${product.variants}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProductScreen(product: product),
          ),
        ).then((updatedProduct) {
          if (updatedProduct != null) {
            // provider.updateProduct(updatedProduct);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 8, 12, 48),
                          ),
                        ),
                      ),
                      Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, _) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A237E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getCategoryName(
                                  categoryProvider, product.category_id),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1A237E),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          debugPrint(
                              'Edit button pressed, variants: ${product.variants}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProductScreen(product: product),
                            ),
                          ).then((updatedProduct) {
                            if (updatedProduct != null) {
                              // provider.updateProduct(updatedProduct);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 12, 94, 35),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(CategoryProvider provider, int? categoryId) {
    try {
      final category = provider.categories.firstWhere(
        (category) => category.id == categoryId,
      );
      return category.name;
    } catch (e) {
      return 'Chưa phân loại';
    }
  }
}
