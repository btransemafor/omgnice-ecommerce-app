import 'package:omgnice_ecommerce_app/features/orders/data/sources/remote/order_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/repositories/order_repository.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteSource remoteSource;
  OrderRepositoryImpl({required this.remoteSource});

  @override
  Future<String> createOrder(OrderEntity orderRequest) async {
    try {
      final order_id = await remoteSource.createOrder(orderRequest);
      return order_id;
    } catch (e) {
      print("Error in createOrder: $e");
      rethrow;
    }
  }

  @override
  Future<List<OrderEntity>> getListOrder() async {
    try {
      final response =
          await remoteSource.getListOrder(); // Trả về List<OrderModel>
      print("REPOSITORIES : ${response.length}");
      return response; // Vì OrderModel extends OrderEntity
    } catch (e) {
      print("Lỗi khi lấy danh sách đơn hàng: $e");
      rethrow;
    }
  }

  // Fetch all order admin
  @override
  Future<List<OrderEntity>> adFetchAllOrder() async {
    return await remoteSource.fetchAllOrder();
  }

  @override
  Future<OrderEntity> getOrderById(String code) async {
    return await remoteSource.getOrderById(code);
  }

  @override
  Future<bool> updateOrderStatus(String orderID , Map<String, dynamic> updateData) async {
    return await remoteSource.updateOrder(orderID, updateData);
  }
}
