// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/payment/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentDTO> createPayment(OrderEntity orderRequest);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl(this.dio);

  @override
  Future<PaymentDTO> createPayment(OrderEntity orderInfo) async {
    // Format items with snake_case field names
    print(orderInfo.promotionId);

    final itemsList = orderInfo.items?.map((item) {
          return {
            "product_id": item.productId,
            "variant_id": item.variantId,
            "quantity": item.quantity,
            "price": item.price,
            "note": item.note,
          };
        }).toList() ??
        [];
    final data = {
      "orderInfo": {
        "address_id": orderInfo.address.id,
        "shipping_method_id": orderInfo.shippingMethodId,
        "shipping_fee": orderInfo.shippingFee,
        "discountAmount": orderInfo.discountAmount,
        "promotion_id": orderInfo.promotionId,
        "orderTotal": orderInfo.orderTotal,
        "note": orderInfo.notes,
        "payment_method": orderInfo.paymentMethod,
        'delivery_time_slot': orderInfo.delivery_time_slot
      },
      "products": itemsList
    };

    print(data);

    final response = await dio.post(
        '/payments/create-payment',
        data: data);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = response.data;
      print('${data}'); 
      return PaymentDTO(
        checkoutUrl: data['checkoutUrl'], //  phải là String
        orderCode: data['orderCode'].toString(), 
        orderId: data['orderId'].toString(),
        message: data['message'],
      );
    } else {
      throw Exception('Đã có lỗi xảy ra: ${response.statusCode}');
    }
  }
}

/* 
@override
Future<PaymentDTO> createCODOrder({
  required String userId,
  required String addressId,
  required String shippingMethodId,
  required String paymentMethod,
  required double orderTotal,
  String? notes,
}) async {
  final response = await dio.post(
    Uri.parse('http://localhost:3000/api/create-payment'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': userId,
      'address_id': addressId,
      'shipping_method_id': shippingMethodId,
      'payment_method': paymentMethod,
      'orderTotal': orderTotal,
      'notes': notes,
    }),
  );

  if (response.statusCode == 200) {
    return PaymentDTO.fromJson(jsonDecode(response.body));
  } else {}
}
 */
