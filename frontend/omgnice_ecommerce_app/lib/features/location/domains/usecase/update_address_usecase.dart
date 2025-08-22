import 'package:omgnice_ecommerce_app/features/location/domains/repositories/address_repository.dart';

class UpdateAddressUsecase {
  final AddressRepository addressRepository; 
  const UpdateAddressUsecase({required this.addressRepository}); 
  Future<bool> call(String id , Map<String, dynamic> updateData) async {
    return await addressRepository.updateAddress(id, updateData); 
  }
}