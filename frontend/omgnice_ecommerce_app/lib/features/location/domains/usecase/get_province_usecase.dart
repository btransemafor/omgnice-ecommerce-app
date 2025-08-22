import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/location.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/repositories/address_repository.dart';

class GetProvinceUsecase {
  final AddressRepository addressRepository; 
  GetProvinceUsecase({required this.addressRepository}); 

  Future<List<Province>> call() async {
    return await addressRepository.getProvinces(); 
  }
}
