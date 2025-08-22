
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/entity/payment.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/repository/payment_repository.dart';

class CreatePaymentUsecase {
  final PaymentRepository repository;

  CreatePaymentUsecase(this.repository);

  Future<Payment> call(OrderEntity orderInfo) async {
    return repository.createPayment(orderInfo); 
  }
}