
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/location.dart';


// Tầng Domains chỉ trả về Entity và không bao giờ biết gì về model - nói đúng là không cần quan tâm model là gì 
abstract class AddressRepository {
  Future<List<Province>> getProvinces(); 
  Future<bool> addNewAddress(AddressEntity newAddress); 
  Future<List<AddressEntity>> fetchListAddress([String? user_id]); 
  Future<bool> deleteAddress(String id); 
  Future<bool> updateAddress(String id, Map<String, dynamic> updateData); 
}