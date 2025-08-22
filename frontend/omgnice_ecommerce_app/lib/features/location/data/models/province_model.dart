import 'package:omgnice_ecommerce_app/features/location/domains/entities/location.dart';

class ProvinceModel extends Province {
  ProvinceModel(
      {required String id,
      required String name,
      required List<District> districts})
      : super(id: id, name: name, districts: districts);

  // Convert Json to ProvinceModel

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
        id: json['id'],
        name: json['name'],
        districts: (json['data2'] as List)
            .map((district) => DistrictModel.fromJson(district))
            .toList());
  }
}

class DistrictModel extends District {
  DistrictModel(
      {required String id,
      required String full_name,
      required List<Ward> wards})
      : super(id: id, full_name: full_name, wards: wards);

  // Convert Json to DistrictModel

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
        id: json['id'],
        full_name: json['full_name'],
        wards: (json['data3'] as List)
            .map((ward) => WardModel.fromJson(ward))
            .toList());
  }
}

class WardModel extends Ward {
  WardModel({
    required String id,
    required String full_name,
  }) : super(id: id, full_name: full_name);

  // Json to model
  factory WardModel.fromJson(Map<String, dynamic> jsonWard) {
    return WardModel(id: jsonWard['id'], full_name: jsonWard['full_name']);
  }
}
