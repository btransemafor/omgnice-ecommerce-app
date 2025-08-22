
import 'package:omgnice_ecommerce_app/features/admin/products/domain/repository/admin_product_repository.dart';

class DeleteProductUsecase {
  final AdminProductRepository adminProductRepository; 
  const DeleteProductUsecase({required this.adminProductRepository}) ; 

  Future<bool> execute(String product_id) async {
    return adminProductRepository.deleteProduct(product_id); 
  }
}