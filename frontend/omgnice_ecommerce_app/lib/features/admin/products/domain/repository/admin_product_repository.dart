import 'dart:io';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';

abstract class AdminProductRepository {
  Future<Product> createProduct(Product p, File imageProduct); 
  Future<List<Product>> fetchListProduct(); 
  Future<void> updateProduct(String product_id, Map<String, dynamic> product, File? updatedImage ); 
  Future<bool> deleteProduct(String product_id); 
}