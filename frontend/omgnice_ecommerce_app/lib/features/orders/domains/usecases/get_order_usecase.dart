
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/repositories/order_repository.dart';

class GetOrderUsecase {
  final OrderRepository orderRepository; 
  const GetOrderUsecase({required this.orderRepository}); 


  Future<List<OrderEntity>> call() async {
    return await orderRepository.getListOrder();  
  }
}