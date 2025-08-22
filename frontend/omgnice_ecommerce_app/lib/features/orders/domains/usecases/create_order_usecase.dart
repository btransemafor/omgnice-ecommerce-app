import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/repositories/order_repository.dart';

class CreateOrderUsecase {
  final OrderRepository orderRepository; 
  const CreateOrderUsecase({required this.orderRepository}); 

  Future<String> call(OrderEntity orderRequest) async {
    // ignore: avoid_print
    print('Đang xử lý tạo order chổ usecase'); 
    final String order_id; 
    order_id = await orderRepository.createOrder(orderRequest); 
    return order_id; 
  }
}