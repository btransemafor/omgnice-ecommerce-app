import '../../domains/entities/location.dart'; 
List<Province> _provinces = [ 
  Province(
    id: "1",
    name: "An Giang",
    districts: [
      District(
        id: "10",
        full_name: "Huyện Châu Thành",
        wards: [
          Ward(id: "100", full_name: "Xã An Hòa"),
          Ward(id: "101", full_name: "Xã Bình Hòa"),
        ],
      ),
      District(
        id: "11",
        full_name: "Huyện Dien Khanh",
        wards: [
          Ward(id: "100", full_name: "Xã An Hòa"),
          Ward(id: "101", full_name: "Xã Bình Hòa"),
        ],
      ),
    ],
  ),
];


void main() {
  // FirstWhere Tim phan tu dau tien trong danh thoa man dieu kien do 
  Province selectedProvince = _provinces.firstWhere((p) => p.id == "1");
  List<District> districts = selectedProvince.districts;
  for ( int i = 0 ; i < districts.length; i++ ) {
    print(districts[i].full_name); 
    if ( i == 1 ) {
      final Wards = districts[i].wards; 
      for (int j = 0 ; j < districts[i].wards.length; j++ ) {
        print(Wards[j].full_name); 
      }
      //print(districts[i].wards); 
    }
  }
  //print(districts[1].full_name); 
}