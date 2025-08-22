import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/repositories/address_repository.dart';

class AddNewAddressUsecase {
  final AddressRepository addressRepository; 
  const AddNewAddressUsecase({required this.addressRepository}); 

  Future<bool> call(AddressEntity newAddress) async {
    try {
        final result = await addressRepository.addNewAddress(newAddress); 
        return result ; 
    }
    catch(error) {
      throw('Erroorrrrrr');
    }
    
  }
}