import 'dart:io';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/repository/admin_product_repository.dart';

class UpdateProductUsecase {
  final AdminProductRepository adminProductRepository;

  const UpdateProductUsecase({required this.adminProductRepository});

  Future<void> call({
    required String productId,
    required Map<String, dynamic> changedFields,
    File? updatedImage,
  }) async {
    try {
      await adminProductRepository.updateProduct(
        productId,
        changedFields,
        updatedImage,
      );
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
