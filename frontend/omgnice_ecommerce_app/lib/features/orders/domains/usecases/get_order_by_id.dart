import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderByIdUseCase {
  final OrderRepository repository;

  const GetOrderByIdUseCase({required this.repository});



  Future<OrderEntity> call(String code) async {
    print("DEBUG: Đang xử lý gọi đơn hàng ở Usecase"); 
    try {
      final data = await repository.getOrderById(code);
      return data;
    } catch (error) {
      throw Exception('$error'); 
    }
  }
}
