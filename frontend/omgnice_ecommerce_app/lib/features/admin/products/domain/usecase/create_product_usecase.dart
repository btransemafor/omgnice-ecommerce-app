import 'dart:io';

import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/repository/admin_product_repository.dart';

class CreateProductUsecase {
  final AdminProductRepository adminProductRepository; 
  const CreateProductUsecase({required this.adminProductRepository}); 
  Future<Product> createProduct(Product p, File imageProduct) async {
    return await adminProductRepository.createProduct(p, imageProduct); 
  }
}