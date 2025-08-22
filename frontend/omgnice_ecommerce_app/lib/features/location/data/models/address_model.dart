import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    String? id,
    required bool is_default,
    String? fullName,
    String? phone,
    required AddressDetailModel address,
  }) : super(
          id: id,
          is_default: is_default,
          fullName: fullName,
          phone: phone,
          address: address,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString(),
      is_default: json['is_default'] as bool? ?? false,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      address: AddressDetailModel.fromJson(
        json['address'] is Map<String, dynamic> ? json['address'] : {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final detailJson = address is AddressDetailModel
        ? (address as AddressDetailModel).toJson()
        : {};

    return {
      'id': id,
      'fullName': fullName ?? '',
      'phone': phone ?? '',
      'is_default': is_default,
      'address': detailJson,
    };
  }
}


class AddressDetailModel extends AddressDetail {
  const AddressDetailModel({
    super.id,
    required super.ward,
    required super.district,
    required super.province,
    super.details,
  });

  factory AddressDetailModel.fromJson(Map<String, dynamic> json) {
    return AddressDetailModel(
      id: _tryParseInt(json['id']),
      ward: json['ward']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      province: json['province']?.toString() ?? '',
      details: json['details']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ward': ward,
      'district': district,
      'province': province,
      'details': details ?? '',
    };
  }

  static int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }


  
}
