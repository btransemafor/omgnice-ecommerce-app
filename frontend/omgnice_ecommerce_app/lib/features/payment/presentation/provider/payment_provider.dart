import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/entity/payment.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/usecase/create_payment.dart';

class PaymentProvider with ChangeNotifier {
  final CreatePaymentUsecase createPayment;

  PaymentProvider(this.createPayment);

  bool _isLoading = false;
  String? _errorMessage;
  Payment? _payment;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Payment? get payment => _payment;

  Future<void> createPaymentLink(OrderEntity orderRequest) async {
    debugPrint("Đang gọi link thanh toán payOS"); 
    _isLoading = true;
    _errorMessage = null;
    _payment = null;
    notifyListeners();

    try {
      final paymentResult = await createPayment.call(orderRequest);
      _payment = paymentResult;
    } catch (e) {
      _errorMessage = 'Không thể tạo liên kết thanh toán: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
