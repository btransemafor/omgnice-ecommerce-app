import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/location.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/add_new_address_usecase.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/usecase/get_province_usecase.dart';

class LocationProvider extends ChangeNotifier {
  final GetProvinceUsecase getProvinceUsecase;

  LocationProvider({required this.getProvinceUsecase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isInit = true;

  final List<Province> _provinces = [];
  final List<District> _districts = [];
  final List<Ward> _wards = [];

  List<Province> get provinces => _provinces;
  List<District> get districts => _districts;
  List<Ward> get wards => _wards;

  String _selectedProvince = '';
  String _selectedDistrict = '';
  String _selectedWard = '';

  String get selectedProvince => _selectedProvince;
  String get selectedDistrict => _selectedDistrict;
  String get selectedWard => _selectedWard;

  bool _isChooseProvince = false;
  bool _isChooseDistrict = false;
  bool _isChooseWard = false;

  bool get isChooseProvince => _isChooseProvince;
  bool get isChooseDistrict => _isChooseDistrict;
  bool get isChooseWard => _isChooseWard;

  String selectedNameProvince = '';
  String selectedNameDistrict = '';
  String selectedNameWard = '';
  String? selectedWardId;
  String? selectedProvinceId;
  String? selectedDistrictId;

  /// Fetch provinces from the usecase
  Future<void> fetchProvinces() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await getProvinceUsecase.call();
      _provinces.clear();
      _provinces.addAll(result);
    } catch (e) {
      debugPrint('Error loading provinces: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterDistrictById(String provinceId) {
    // Reset Name
    selectedProvinceId = provinceId;
    _isChooseProvince = true;
    selectedNameProvince = '';
    Province selectedProvince =
        _provinces.firstWhere((province) => province.id == provinceId);
    List<District> districtsOfSelectedProvince = selectedProvince.districts;
    selectedNameProvince = selectedProvince.name;
    _districts.clear();
    _districts.addAll(districtsOfSelectedProvince);
    notifyListeners();
  }

  void filterWardById(String districtId) {
    selectedDistrictId = districtId;
    _isChooseDistrict = true;

    // Reset name
    selectedNameDistrict = '';
    final selectedDistrict =
        _districts.firstWhere((district) => district.id == districtId);
    _wards.clear();
    // Get Ward
    _wards.addAll(selectedDistrict.wards);
    selectedNameDistrict = selectedDistrict.full_name;
    notifyListeners();
  }

  void getNameWardById(String id) {
    selectedWardId = id;
    _isChooseWard = true;
    Ward ward = _wards.firstWhere((w) => w.id == id);
    selectedNameWard = ward.full_name;
    notifyListeners();
  }

  // Khi nhấn vào CardAddress để chỉnh sửa => Xem nó là tỉnh huyện xã
  // + Nếu tỉnh
  void resetToChooseProvince() {
    _isChooseProvince = false;
    _isChooseDistrict = false;
    _isChooseWard = false;
    selectedNameProvince = '';
    selectedNameDistrict = '';
    selectedNameWard = '';
    selectedWardId = '';
    selectedProvinceId = '';
    selectedDistrictId = '';
    notifyListeners();
  }

  void resetToChooseDistrict() {
    selectedProvinceId = '';
    selectedDistrictId = '';
    _isChooseProvince = true;
    _isChooseDistrict = false;
    _isChooseWard = false;
    selectedNameDistrict = '';
    selectedNameWard = '';

    notifyListeners();
  }

  void resetToChooseWard() {
    _isChooseProvince = true;
    _isChooseDistrict = true;
    selectedWardId = '';
    _isChooseWard = false;
    selectedNameDistrict = '';
    selectedNameWard = '';
    notifyListeners();
  }

  void chooseProvince(String id) {}

// _provinces
// _districts
// _wards

// SearchedList
  final List<Province> _searchedProvinces = [];
  final List<District> _searchedDistricts = [];
  final List<Ward> _searchedWards = [];

  List<Province> get searchedProvince => _searchedProvinces;
  List<District> get searchedDistrict => _searchedDistricts;
  List<Ward> get searchedWards => _searchedWards;

  void searchLocation(query, String typeSearch) {
    // TypeSearch : Search Province, Search District
    if (typeSearch == 'province') {
      _searchedProvinces.clear();
      _searchedProvinces.addAll(_provinces.where((element) =>
          element.name.toLowerCase().contains(query.toLowerCase())));
    } else if (typeSearch == 'district') {
      _searchedDistricts.clear();
      _searchedDistricts.addAll(_districts.where((element) =>
          element.full_name.toLowerCase().contains(query.toLowerCase())));
    } else if (typeSearch == 'ward') {
      _searchedWards.clear();
      _searchedWards.addAll(_wards.where((element) =>
          element.full_name.toLowerCase().contains(query.toLowerCase())));
    }
    notifyListeners();
  }



  void clearSearch() {
    _searchedDistricts.clear() ; 
    _searchedProvinces.clear(); 
    _searchedWards.clear(); 
    notifyListeners(); 
  }

  List<Province> get provincesToDisplay =>
      _searchedProvinces.isNotEmpty ? _searchedProvinces : _provinces;

  List<District> get districtsToDisplay =>
      _searchedDistricts.isNotEmpty ? _searchedDistricts : _districts;

  List<Ward> get wardsToDisplay =>
      _searchedWards.isNotEmpty ? _searchedWards : _wards;
}
