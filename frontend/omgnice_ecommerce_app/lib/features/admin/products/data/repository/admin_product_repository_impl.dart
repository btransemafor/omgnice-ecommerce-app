import 'dart:io';

import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/data/source/admin_product_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/repository/admin_product_repository.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/data/models/product_model.dart'
    as adProductModel;

class AdminProductRepositoryImpl implements AdminProductRepository {
  final AdminProductRemoteSource adminProductRemoteSource;
  const AdminProductRepositoryImpl({required this.adminProductRemoteSource});
  @override
  Future<Product> createProduct(Product p, File imageProduct) async {
    // Convert into model
    final productModel = adProductModel.ProductModel(
        name: p.name,
        description: p.description,
        imageUrl: p.imageUrl ?? '',
        discountPercent: p.discountPercent,
        soldQuantity: p.soldQuantity ?? 0,
        isHidden: p.isHidden,
        variants: p.variants,
        category_id: p.category_id);
    return await adminProductRemoteSource.createProduct(
        productModel, imageProduct);
  }

  @override
  Future<List<Product>> fetchListProduct() async {
    print('---> Bat dau lay danh sach san pham <------');
    final listProductModel = await adminProductRemoteSource.getProducts();
    print(listProductModel[1].variants);
    return listProductModel
        .map((e) => Product(
            id: e.id,
            name: e.name,
            description: e.description,
            imageUrl: e.imageUrl,
            discountPercent: e.discountPercent,
            soldQuantity: e.soldQuantity,
            isHidden: e.isHidden,
            variants: e.variants,
            category_id: e.category_id))
        .toList();
  }

  @override
  Future<void> updateProduct(String productId,
      Map<String, dynamic> changedFields, File? updatedImage) async {
    debugPrint("DEBUG: ---- Đang gọi tới remote để PATCH Product");

    await adminProductRemoteSource.updateProduct(
      productId,
      changedFields,
      updatedImage,
    );
  }

  @override
  Future<bool> deleteProduct(String product_id) async {
    debugPrint(
        "DEBUG: ---- Đang gọi tới remote để Delete Product ------------- ");
    try {

      return await adminProductRemoteSource.deleteProduct(product_id);
    } catch (error, stackTrace) {
      debugPrint('Error deleting product: $error, $stackTrace');
      // Optionally report error to monitoring service, e.g., Firebase Crashlytics
      return false; // hoặc rethrow nếu bạn muốn ném lỗi tiếp
    }
  }
}
