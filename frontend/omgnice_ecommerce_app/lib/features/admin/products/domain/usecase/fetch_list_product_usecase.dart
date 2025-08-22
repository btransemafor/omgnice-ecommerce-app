import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/repository/admin_product_repository.dart';

class FetchListProductUsecase {
  final AdminProductRepository _productRepository; 
  FetchListProductUsecase(this._productRepository); 
  Future<List<Product>> execute() async {
    // ignore: avoid_print
    print('Đang xử lý lấy danh sách sản phẩm chổ usecase'); 
    final List<Product> listProduct = await _productRepository.fetchListProduct(); 
    print('Danh sách sản phẩm đã lấy thành công: ${listProduct.length} sản phẩm'); 
    debugPrint('Test sản phẩm 1 ${listProduct[0].variants}'); 
    return listProduct; 
  }
}