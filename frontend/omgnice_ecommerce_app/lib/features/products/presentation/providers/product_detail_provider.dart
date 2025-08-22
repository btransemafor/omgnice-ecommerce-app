import 'package:flutter/material.dart';

class ProductDetailProvider extends ChangeNotifier {
  int _quantity = 1;
  double _total = 0;
  String? _noteForOrder = ''; 
  double _selectedPrice = 0.0; 

  double get total => _total;
  int get quantity => _quantity;
  String? get noteForOrder => _noteForOrder;

  void saveNote(String? note) {
    _noteForOrder = note;
    notifyListeners();
  }

  void resetNote() {
    _noteForOrder = ''; 
    notifyListeners(); 
  }

  void increaseQuantity() {
    _quantity += 1;
    calculateTotalPrice();
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      calculateTotalPrice();
      notifyListeners();
    }
  }

  void calculateTotalPrice() {
    _total = _quantity * _selectedPrice;
    notifyListeners();
  }
}
