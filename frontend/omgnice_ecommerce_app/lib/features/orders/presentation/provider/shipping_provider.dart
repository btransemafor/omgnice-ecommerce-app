import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';

class ShippingProvider extends ChangeNotifier  {
  ShippingMethodEntity? _selectShipping; 
  ShippingMethodEntity? get selectShipping => _selectShipping; 

  void ChooseShippingMethod(ShippingMethodEntity shippingMethod) {
    _selectShipping = shippingMethod; 
    notifyListeners(); 
  }
}