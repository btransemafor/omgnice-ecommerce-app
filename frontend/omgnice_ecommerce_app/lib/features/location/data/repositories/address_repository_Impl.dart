// Right here, you convert ProvinceModel → ProvinceEntity.
// Why? Because the Domain Layer only knows about Entities.
import 'package:omgnice_ecommerce_app/features/location/data/models/address_model.dart';
import 'package:omgnice_ecommerce_app/features/location/data/sources/location_remote_source_impl.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/location.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final LocationRemoteSource locationRemoteSource;
  AddressRepositoryImpl({required this.locationRemoteSource});

  @override
  Future<List<Province>> getProvinces() async {
    // Implement the method logic here
    final listModel = await locationRemoteSource.getProvinces();
    // chuyen Model thanh Entity
    return listModel
        .map((provinceModel) => Province(
            id: provinceModel.id,
            name: provinceModel.name,
            districts: provinceModel.districts))
        .toList();
  }

  @override
  Future<bool> addNewAddress(AddressEntity newAddress) async {
    print(
        "🧩 Repository: Nhận entity: ${newAddress.fullName} - ${newAddress.phone}");

    AddressModel model = AddressModel(
        is_default: newAddress.is_default,
        fullName: newAddress.fullName,
        phone: newAddress.phone,
        address: AddressDetailModel(
            ward: newAddress.address.ward,
            district: newAddress.address.district,
            province: newAddress.address.province,
            details: newAddress.address.details ?? ''));

    return await locationRemoteSource.addNewAddress(model);
  }

  @override
  Future<List<AddressEntity>> fetchListAddress([String? user_id]) async {
    final addressModelList = await locationRemoteSource.fetchListAddress(user_id);
    print('GOi toi remote ');
    final addressEntityList = addressModelList
        .map((model) => AddressEntity(
              id: model.id,
              is_default: model.is_default,
              fullName: model.fullName,
              phone: model.phone,
              address: AddressDetailModel(
                id: model.address.id!,
                ward: model.address.ward,
                district: model.address.district,
                province: model.address.province,
                details: model.address.details,
              ),
            ))
        .toList();
    return addressEntityList;
  }
  @override

  Future<bool> deleteAddress(String id) async {
    return await locationRemoteSource.deleteAddress(id); 
  }

  Future<bool> updateAddress(String id, Map<String , dynamic > updateData) async {
    return await locationRemoteSource.updateAddress(id, updateData); 
  }
}
