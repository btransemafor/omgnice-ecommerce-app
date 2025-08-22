import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/add_new_address_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/delete_address_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/fetch_list_address_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/update_address_usecase.dart';

class AddressProvider extends ChangeNotifier  {
  final AddNewAddressUsecase addNewAddressUsecase; 
  final FetchListAddressUsecase fetchListAddressUsecase; 
  final DeleteAddressUsecase deleteAddressUsecase; 
  final UpdateAddressUsecase updateAddressUsecase; 
  AddressProvider({
    required this.addNewAddressUsecase, 
    required this.fetchListAddressUsecase, 
    required this.deleteAddressUsecase, 
    required this.updateAddressUsecase
    }); 

  bool _isLoading = false; 
  bool _isSuccess = false; 
  String _errorMessage = ''; 

  bool get isLoading => _isLoading; 
  bool get isSuccess => _isSuccess; 
  String get errorMessage => _errorMessage; 

  AddressEntity? defaultAddr; 


  // List Address 
  List<AddressEntity> _addresses = []; 
  List<AddressEntity> get addresses => _addresses; 

  /// ------------------- Add New Address --------------------- // 
Future<void> addNewAddress(AddressEntity newAddress) async {
  _isLoading = true;
  _isSuccess = false;
  notifyListeners();

  try {
    print("Gọi usecase addNewAddressUsecase");
    final result = await addNewAddressUsecase.call(newAddress);
    print("Kết quả gọi usecase: $result");

    _isSuccess = result;
  } catch (e) {
    _errorMessage = "Error: $e";
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

/// ------------------ Delete Address ---------------------- // 
Future<void> deleteAddress(String id) async {
  _isLoading = true;
  _isSuccess = false;
  _errorMessage = '';
  notifyListeners();

  try {
    _isSuccess = await deleteAddressUsecase.call(id);

    if (_isSuccess) {
      final index = _addresses.indexWhere((item) => item.id == id);
      if (index != -1) {
        _addresses.removeAt(index);
      }
    }
  } catch (error) {
    _errorMessage = "Cannot delete address.";
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

 /// ------------------- Fetch List Address ------------------- // 
Future<void> fetchListAddress([String? user_id]) async {

  _isLoading = true;
  _isSuccess = false;
  _addresses = [];
  _errorMessage = '';

  try {
    print('Goi usecase featch ');
    _addresses = await fetchListAddressUsecase.call(user_id);
    

    if (_addresses.isNotEmpty) {
      _isSuccess = true;
    }
  } catch (error) {
    _errorMessage = 'Error fetching address: $error';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


// Get address là địa chỉ mặt định 
AddressEntity? defaultAddress() {
  // Loc qua ds address get tu server 
  defaultAddr = null; 
  for(final itemAddress in _addresses ) {
    if (itemAddress.is_default == true ) {
      defaultAddr = itemAddress; 
      notifyListeners(); 
      return itemAddress; 
    }
  }
  return null; 
}

  
  // ----------------------- Update Address Usecase ------------------------- // 
Future<bool> updateAddress(String id, Map<String, dynamic> updateData) async {
  _isLoading = true;
  _isSuccess = false;
  _errorMessage = '';
  notifyListeners();

  try {
    _isSuccess = await updateAddressUsecase.call(id, updateData);
    return _isSuccess;
  } catch (error) {
    _errorMessage = 'Error Updating Address: $error';
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}