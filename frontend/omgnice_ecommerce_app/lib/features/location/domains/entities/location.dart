// ignore_for_file: non_constant_identifier_names

class Province {
  String id;
  String name;
  Province({required this.id, required this.name, required this.districts});
  List<District> districts;
}

class District {
  String id;
  String full_name;
  List<Ward> wards;
  District({required this.id, required this.full_name, required this.wards});
}

class Ward {
  String id;
  String full_name;
  Ward({required this.id, required this.full_name});
}
