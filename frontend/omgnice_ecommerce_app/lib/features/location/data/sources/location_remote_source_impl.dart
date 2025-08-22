import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/location/data/models/address_model.dart';
import 'package:omgnice_ecommerce_app/features/location/data/models/province_model.dart';

abstract class LocationRemoteSource {
  Future<List<ProvinceModel>> getProvinces();
  Future<bool> addNewAddress(AddressModel newAdress);
  Future<List<AddressModel>> fetchListAddress([String? user_id]);
  Future<bool> deleteAddress(String id);
  Future<bool> updateAddress(String id, Map<String, dynamic> updateData);
}

class LocationRemoteSourceImpl implements LocationRemoteSource {
  final Dio dio = DioClient().client;

  @override
  Future<List<ProvinceModel>> getProvinces() async {
    const url_api = 'https://esgoo.net/api-tinhthanh/4/0.htm';
    try {
      final response = await dio.get(url_api,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data == null || data['data'] == null) {
          throw Exception('Dữ liệu trả về không hợp lệ');
        }

        final List<dynamic> result = data['data'] as List;
        return result
            .map<ProvinceModel>((province) =>
                ProvinceModel.fromJson(province as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }
@override
Future<bool> addNewAddress(AddressModel newAddress) async {
  developer.log("RemoteSource: Bắt đầu gửi API addNewAddress");
  
  // Log dữ liệu trước khi gửi
  developer.log("${newAddress.toJson()}");
  
  // Tạo data "phẳng" thay vì lồng nhau
  final data = {
    "is_default": newAddress.is_default,
    "fullName": newAddress.fullName,
    "phone": newAddress.phone,
    "district": newAddress.address.district,
    "ward": newAddress.address.ward,
    "province": newAddress.address.province, 
    "details": newAddress.address.details
  };
  
  // Log data sau khi format
  developer.log("DATA REQUEST: ${jsonEncode(data)}");
  
  try {
    final response = await dio.post(
      '/address/',
      data: data,
      options: Options(
        headers: {"Content-Type": "application/json"}
      ),
    );

    developer.log("RESPONSE STATUS: ${response.statusCode}");
    developer.log("RESPONSE DATA: ${response.data}");

    if (response.statusCode == 200) {
      developer.log('Post New Address Successfully');
      return true;
    } else {
      developer.log('Server trả lỗi: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    developer.log('Error: $e');
    // Thêm log về error response nếu có
    if (e is DioException) {
      developer.log('Error Response: ${e.response?.data}');
    }
    return false;
  }
}
 @override
Future<List<AddressModel>> fetchListAddress([String? userId]) async {
  try {
    // Xác định URL phù hợp
    print("DANG FETCH DIA CHI NE!");
    final url = userId != null ? '/address/$userId' : '/address';

    print(userId); 

    final response = await dio.get(url);

    print(response.statusCode); 

    if (response.statusCode == 200) {
      final json = response.data;
      final List<AddressModel> list = (json['data'] as List)
          .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return list;
    } else {
      throw Exception("Fetch address failed: ${response.statusCode}");
    }
  } catch (e, stack) {
    developer.log("Fetch Address Error", error: e, stackTrace: stack);
    throw Exception("Lỗi khi lấy danh sách địa chỉ: $e");
  }
}


  @override
  Future<bool> deleteAddress(String id) async {
    try {
      final response = await dio.delete('/address/$id');

      if (response.statusCode == 200) {
        print("Delete Address Successfully");
        return true;
      } else {
        print("Không thể xoá địa chỉ");
        return false;
      }
    } catch (e) {
      print("Error deleting address: $e");
      return false;
    }
  }

  @override
  Future<bool> updateAddress(String id, Map<String, dynamic> updateData) async {
    try {
      final response = await dio.put(
        '/address/$id',
        data: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        developer.log("Update Address thành công: $id");
        return true;
      } else {
        developer.log("Update thất bại");
        return false;
      }
    } catch (e) {
      developer.log("Update Address Error: $e");
      return false;
    }
  }
}
