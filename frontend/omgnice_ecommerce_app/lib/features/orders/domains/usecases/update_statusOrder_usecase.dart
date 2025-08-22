import 'package:omgnice_ecommerce_app/features/orders/domains/repositories/order_repository.dart';

class UpdateStatusorderUsecase {
  final OrderRepository orderRepository; 
  const UpdateStatusorderUsecase({required this.orderRepository}); 
  Future<bool> call(String orderID, Map<String, dynamic> updateData) async {
    return orderRepository.updateOrderStatus(orderID, updateData); 
  }
}