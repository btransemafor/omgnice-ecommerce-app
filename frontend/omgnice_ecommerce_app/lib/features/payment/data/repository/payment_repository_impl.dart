import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/payment/data/source/payment_remote_datasource.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/entity/payment.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Payment> createPayment(OrderEntity orderInfo) async {
    try {
      final paymentDTO = await remoteDataSource.createPayment(orderInfo); 
      print("REPSITORY : ${paymentDTO.checkoutUrl}");
      return paymentDTO;
    } catch (e, stack) {
      print("Error in createPayment: $e\n$stack");
      rethrow;
    }
  }
}
