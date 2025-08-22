
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/entity/payment.dart';

abstract class PaymentRepository {
  Future<Payment> createPayment(OrderEntity orderInfo);
}