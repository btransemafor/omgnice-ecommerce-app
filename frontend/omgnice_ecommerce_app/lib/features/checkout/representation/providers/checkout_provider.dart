import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/checkout/representation/providers/checkout_state.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';

class CheckoutProvider extends ChangeNotifier {

  // Lấy dữ liệu về chọn adddress, chọn shipping, ở những provider khác 
  
  late CheckoutState _state;

  CheckoutState get state => _state;

  CheckoutProvider({
    required AddressEntity defaultAddress,
    required ShippingMethodEntity defaultShipping,
    required String defaultPayment,
  }) {
    _state = CheckoutState.initialWithDefaults(
      address: defaultAddress,
      shipping: defaultShipping,
      payment: defaultPayment,
    );
  }
  // Set Address
  void setAddress(AddressEntity selectedAddress) {
    // Tao bang sao của CheckoutState ban đầu va chi truyen su thay doi 
    // _state.copyWith(selectedAddress: selectedAddress);  Nếu không gán lại là sai 
    
    // vì cái kia nó trả về một bảng sao của state ban đầu đã chỉnh chứ không phải set trên cái ban đầu 
    // nên cần gán lại 
    _state = _state.copyWith(selectedAddress: selectedAddress); 
    notifyListeners(); 
  }
  // Set Payment 
  void setPayment(String payment) {
    _state = _state.copyWith(selectedPayment: payment); 
    notifyListeners(); 
  }

  // Set Shipping Address 
  void setShippingAddress(ShippingMethodEntity shipping) {
    _state = _state.copyWith(selectedShippingMethod:  shipping); 
    notifyListeners(); 
  }

}
