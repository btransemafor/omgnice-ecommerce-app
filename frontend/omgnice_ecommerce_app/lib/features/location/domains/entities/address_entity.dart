class AddressEntity {
  final String? id;
  final bool is_default;
  final String? fullName;
  final String? phone;

  AddressDetail address; //  gợi ý đổi tên

  AddressEntity({
    this.id, 
    required this.is_default, 
    this.fullName, 
    this.phone, 
    required this.address
  }); 
}

class AddressDetail {
  final int? id;
  final String ward;
  final String district;
  final String province;
  final String? details;

  const AddressDetail({
    this.id,
    required this.ward,
    required this.district,
    required this.province,
    this.details,
  });
}
