
import 'package:omgnice_ecommerce_app/features/payment/domain/entity/payment.dart';

class PaymentDTO extends Payment {
  final String? message;
  final String? orderCode;
  final String? bin;
  final String? accountNumber;
  final String? accountName;
  final int? amount;
  final String? qrCode;
  final String? error;
  final String? details;

  PaymentDTO({
    String? checkoutUrl,
    String? orderId,
    String? orderCode,
    this.message,
    this.bin,
    this.accountNumber,
    this.accountName,
    this.amount,
    this.qrCode,
    this.error,
    this.details,
  })  : orderCode = orderCode,
        super(checkoutUrl: checkoutUrl, orderId: orderId, orderCode: orderCode);

  factory PaymentDTO.fromJson(Map<String, dynamic> json) {
    print("Parsing JSON: $json"); // Debug log

    if (json['error'] != null) {
      return PaymentDTO(
        error: json['error'] as String?,
        details: json['details'] as String?,
      );
    }

    final data = json; // Assuming flat structure based on backend log
    return PaymentDTO(
      checkoutUrl: data['checkoutUrl'] as String?,
      orderId: data['orderId']?.toString(),
      orderCode: data['orderCode'].toString(),
      message: data['message'] as String?,
      bin: data['bin'] as String?,
      accountNumber: data['accountNumber'] as String?,
      accountName: data['accountName'] as String?,
      amount: data['amount'] as int?,
      qrCode: data['qrCode'] as String?,
      error: json['error'] as String?,
      details: json['details'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkoutUrl': checkoutUrl,
      'orderId': orderId,
      'orderCode': orderCode, 
      'message': message,
      'bin': bin,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'amount': amount,
      'qrCode': qrCode,
      'error': error,
      'details': details,
    };
  }

  @override
  String toString() {
    return 'PaymentDTO(checkoutUrl: $checkoutUrl, orderId: $orderId, orderCode: $orderCode, message: $message, error: $error, details: $details)';
  }
}