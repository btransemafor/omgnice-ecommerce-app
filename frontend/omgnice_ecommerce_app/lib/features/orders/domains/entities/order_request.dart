import './orderInfo.dart';
import './order_item_entity.dart';

class OrderRequest {
  final OrderInfo orderInfo;
  final List<OrderItemEntity> products;

  OrderRequest({
    required this.orderInfo,
    required this.products,
  });
}
