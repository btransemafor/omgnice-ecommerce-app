
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getListOrder(); 
  Future<String> createOrder(OrderEntity orderRequest); 
  Future<OrderEntity> getOrderById(String code); 
  Future<List<OrderEntity>> adFetchAllOrder(); 
  Future<bool>updateOrderStatus(String orderID, Map<String, dynamic> updateData); 
}