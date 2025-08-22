
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/orderInfo.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_request.dart';

import './order_item_model.dart'; 
class OrderRequestModel extends OrderRequest {

  OrderRequestModel({
    required OrderInfo orderInfo,
    required List<OrderItemModel> products,
  }) : super(orderInfo: orderInfo, products: products);

}