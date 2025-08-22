import 'package:omgnice_ecommerce_app/features/location/domains/repositories/address_repository.dart';

class DeleteAddressUsecase {
  final AddressRepository addressRepository; 
  const DeleteAddressUsecase({required this.addressRepository}); 
  Future<bool> call(String id) async {
    return await addressRepository.deleteAddress(id); 
  }
}