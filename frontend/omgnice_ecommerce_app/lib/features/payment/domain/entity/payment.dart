class Payment {
  final String? checkoutUrl;
  final String? orderId;
  final String? orderCode; 

  Payment({this.checkoutUrl, this.orderId, this.orderCode});
  @override
  String toString() {
    return 'Payment(orderCode: $orderId, checkoutUrl: $checkoutUrl)';
  }
}