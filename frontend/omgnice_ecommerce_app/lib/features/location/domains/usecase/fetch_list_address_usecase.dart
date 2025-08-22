import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/repositories/address_repository.dart';

class FetchListAddressUsecase {
  final AddressRepository addressRepository; 

  const FetchListAddressUsecase({required this.addressRepository}); 

  Future<List<AddressEntity>> call([String? user_id]) async {
    return addressRepository.fetchListAddress(user_id); 
  }
}