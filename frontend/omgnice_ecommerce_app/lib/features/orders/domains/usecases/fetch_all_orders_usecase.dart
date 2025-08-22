import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/repositories/order_repository.dart';

class FetchAllOrdersUsecase { 
  final OrderRepository orderRepository; 
  const FetchAllOrdersUsecase({
    required this.orderRepository
  }); 

  Future<List<OrderEntity>> fetchAllOrders() async {
     return await orderRepository.adFetchAllOrder(); 
  }
}