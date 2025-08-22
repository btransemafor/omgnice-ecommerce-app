// ProductDetailLoadingScreen.dart
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/pages/product_detail_screen.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_detail_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:omgnice_ecommerce_app/features/reviews/presentation/provider/review_provider.dart';
import 'package:provider/provider.dart';
class ProductDetailLoadingScreen extends StatefulWidget {
  final int productId;

  const ProductDetailLoadingScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailLoadingScreen> createState() => _ProductDetailLoadingScreenState();
}

class _ProductDetailLoadingScreenState extends State<ProductDetailLoadingScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final productProvider = context.read<ProductProvider>();
    final detailProvider = context.read<ProductDetailProvider>();
    final cartProvider = context.read<CartProvider>();
    final reviewProvider = context.read<ReviewProvider>();

    try {
      // Reset all states
      detailProvider.resetNote();
      productProvider.resetSelectedSize();
      await cartProvider.getCart();
      await reviewProvider.getReviews(widget.productId);
      await productProvider.getProductDetailById(widget.productId);

      if (!mounted) return;

      final productDetail = productProvider.productDetail;

      if (productDetail == null) {
        _navigateError('Không tìm thấy thông tin sản phẩm');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: productDetail),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      _navigateError('Đã xảy ra lỗi: $e');
    }
  }

  void _navigateError(String message) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(child: Text(message)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CustomLoading(),
      ),
    );
  }
}
