import 'dart:io';
import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/orders/data/models/shipping_method.dart'; 
import 'package:dio/dio.dart';

abstract class ShippingRemoteSource {
  Future<List<ShippingMethodModel>> getShippingMethods(); 
}

class ShippingRemoteSourceImpl implements ShippingRemoteSource {
  final Dio dio = DioClient().client;
  @override
  Future<List<ShippingMethodModel>> getShippingMethods() async {
    try {
      final response = await dio.get('/shipping', 
      options: Options(
         headers: {
            "Content-Type": "application/json",
            "Accept": "application/json" 
          },
      )
      ); 

      if (response.statusCode == 200) {
        final data = response.data['data'] as List ; 
        stderr.writeln('Get Shipping Method Successfully!');  
        return data.map((item) => ShippingMethodModel.fromJson(item)).toList(); 
      }
      else {
        stderr.writeln('Get Shipping Method Failed!');
      }
      throw Exception('Unexpected error occurred while fetching shipping methods.');
    }
    catch(error) {
      stderr.writeln('Get Shipping Method Failed'); 
      rethrow; 
    }
  }
}