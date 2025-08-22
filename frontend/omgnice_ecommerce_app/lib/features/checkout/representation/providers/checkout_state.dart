import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';

class CheckoutState {
  // ShippingAddressEntity
  final AddressEntity? selectedAddress;
  // Shipping Method
  // Payment Method
  final String? selectedPayment;
  final ShippingMethodEntity? selectedShipping;
  // final String? delivery_time_slot; 

  


  CheckoutState(
      {this.selectedAddress, this.selectedPayment, this.selectedShipping});

  // CopyWith
  CheckoutState copyWith(
      {AddressEntity? selectedAddress,
      String? selectedPayment,
      ShippingMethodEntity? selectedShippingMethod}) {
    return CheckoutState(
        selectedAddress: selectedAddress ?? this.selectedAddress,
        selectedPayment: selectedPayment ?? this.selectedPayment,
        selectedShipping: selectedShippingMethod ?? this.selectedShipping);
  }


/*

  CopyWith cho phep cập nhật một phần của object mà vẫn giữ nguyên các phần khác.
  
  CopyWith tạo ra một bản sao mới của object, nhưng bạn có thể truyền vào các giá trị muốn thay đổi 

*/

  ///  Trạng thái khởi tạo với các lựa chọn mặc định
  static CheckoutState initialWithDefaults({
    required AddressEntity address,
    required ShippingMethodEntity shipping,
    required String payment,
  }) {
    return CheckoutState(
      selectedAddress: address,
      selectedShipping: shipping,
      selectedPayment: payment,
    );
  }



}
