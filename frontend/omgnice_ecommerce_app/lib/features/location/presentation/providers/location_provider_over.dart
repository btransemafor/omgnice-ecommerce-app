import 'package:omgnice_ecommerce_app/features/location/data/repositories/address_repository_Impl.dart';
import 'package:omgnice_ecommerce_app/features/location/data/sources/location_remote_source_impl.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/add_new_address_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/delete_address_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/fetch_list_address_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/get_province_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/update_address_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LocationProviderOver {
  static Future<ChangeNotifierProvider> getLocationProvider() async  {
    // Dependency Injection
    final remoteDataSource = LocationRemoteSourceImpl(); 
    final addressRepositoryImpl = AddressRepositoryImpl(locationRemoteSource: remoteDataSource);
    final getProvinceUseCase = GetProvinceUsecase(addressRepository: addressRepositoryImpl); 
    //final addrNewAddressUseCase = AddNewAddressUsecase(addressRepository: addressRepositoryImpl); 

    return ChangeNotifierProvider<LocationProvider> (create: (_) => LocationProvider(
      getProvinceUsecase: getProvinceUseCase, 
     )); 

    
     

  }
}
class AddressProviderOver {
  static Future<ChangeNotifierProvider> getAddressProvider() async {
    final remoteDataSource = LocationRemoteSourceImpl(); 
    final addressRepositoryImpl = AddressRepositoryImpl(locationRemoteSource: remoteDataSource);
    final addrNewAddressUseCase = AddNewAddressUsecase(addressRepository: addressRepositoryImpl); 
    final fetchListAddress = FetchListAddressUsecase(addressRepository: addressRepositoryImpl); 
    final deleteAddress = DeleteAddressUsecase(addressRepository: addressRepositoryImpl);
    final updateAddress = UpdateAddressUsecase(addressRepository: addressRepositoryImpl) ;
    return ChangeNotifierProvider<AddressProvider> (create: (_) =>  AddressProvider(
      addNewAddressUsecase: addrNewAddressUseCase, 
      fetchListAddressUsecase: fetchListAddress,
       deleteAddressUsecase: deleteAddress, 
       updateAddressUsecase: updateAddress
       )); 
  }
}