// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/location/data/models/address_model.dart';
import 'package:omgnice_ecommerce_app/features/orders/data/models/order_item_model.dart';
import 'package:omgnice_ecommerce_app/features/orders/data/models/order_model.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
abstract class OrderRemoteSource {
  Future<String> createOrder(OrderEntity orderInfo);
  Future<List<OrderModel>> getListOrder();
  Future<OrderModel> getOrderById(String code);
  Future<List<OrderModel>> fetchAllOrder();
  Future<bool> updateOrder(String orderID,  Map<String, dynamic> updateData);
}

class OrderRemoteSourceImpl implements OrderRemoteSource {
  final Dio dio = DioClient().client;

  @override
  Future<String> createOrder(OrderEntity orderInfo) async {
    try {
      print(orderInfo.promotionId);

      final itemsList = orderInfo.items?.map((item) {
            return {
              "product_id": item.productId,
              "variant_id": item.variantId,
              "quantity": item.quantity,
              "price": item.price,
              "note": item.note,
              "isReview": item.is_review
            };
          }).toList() ??
          [];
      final data = {
        "orderInfo": {
          "address_id": orderInfo.address.id,
          "shipping_method_id": orderInfo.shippingMethodId,
          "shipping_fee": orderInfo.shippingFee,
          "discountAmount": orderInfo.discountAmount,
          "promotion_id": orderInfo.promotionId,
          "orderTotal": orderInfo.orderTotal,
          "note": orderInfo.notes,
          "payment_method": orderInfo.paymentMethod,
          'delivery_time_slot': orderInfo.delivery_time_slot
        },
        "products": itemsList
      };

      
      print("Đang xử lý gửi dữ liệu tới server ");
      final response = await dio.post(
        "/orders/",
        data: data,
      );



      

      if (response.statusCode == 201 && response.data['data'] != null) {
        final data = response.data['data'];
        print(data); 
        final order_id = data['id'];
        print(
            "------------- Order created successfully: $order_id ---------------- ");
        return order_id;
      } else {
        print("Lỗi khi tạo đơn hàng: ${response.data['message']}");
        throw Exception("Failed to create order: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception("Failed to load banners: ${e.message}");
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception("An unexpected error occurred");
    }
  }

  @override
  Future<OrderModel> getOrderById(String code) async {
    print("Dang goi toi server");
    final response = await dio.get('/orders/$code');
    print(response.statusCode);

    if (response.statusCode == 200) {
      final orderData = response.data['data'] ?? response.data;

      orderData.forEach((key, value) {
        print("Key: $key, Type: ${value.runtimeType}, Value: $value");
      });

      if (orderData['items'] != null && orderData['items'].isNotEmpty) {
        final firstItem = orderData['items'][0];
        firstItem.forEach((key, value) {
          print("Item key: $key, Type: ${value.runtimeType}, Value: $value");
        });
        print("Item quantity type: ${firstItem['quantity'].runtimeType}");
        print("Item price type: ${firstItem['price'].runtimeType}");
      }

      try {
        final total = orderData['total'] is String
            ? double.parse(orderData['total'])
            : (orderData['total'] as num).toDouble();

        final deliveryFee = orderData['deliveryFee'] is String
            ? double.parse(orderData['deliveryFee'])
            : (orderData['deliveryFee'] as num).toDouble();

        final discount = orderData['promotionDiscount'] is String
            ? double.parse(orderData['promotionDiscount'])
            : (orderData['promotionDiscount'] as num).toDouble();

        final promotionId = orderData['promotion_id'] != null
            ? (orderData['promotion_id'] is String
                ? int.tryParse(orderData['promotion_id'])
                : orderData['promotion_id'] as int?)
            : null;

        List<OrderItemModel> orderItems = [];
        if (orderData['items'] != null) {
          for (var item in orderData['items']) {
           
            final quantity = item['quantity'] is String
                ? int.parse(item['quantity'])
                : item['quantity'] as int;

            final price = item['price'] is String
                ? double.parse(item['price'])
                : (item['price'] as num).toDouble();

            orderItems.add(OrderItemModel(
              is_review: item['isReview'],
              productId: item['product_id'],
              variantId: item['variant_id'],
              quantity: quantity,
              price: price,
              note: item['note']?.toString() ?? '',
              productName: item['name']?.toString() ?? '',
              variantName: item['variantName']?.toString() ?? '',
              thumbnail: item['thumbnail']?.toString() ?? '',
            ));
          }
        }

        Map<String, dynamic> addressData =
            orderData['address'] as Map<String, dynamic>;

        final orderModel = OrderModel(
          paymentStatus: orderData['paymentStatus'],
          paidAt: orderData['paidAt'] != null
              ? DateTime.parse(orderData['paidAt'].toString())
              : null,
          id: orderData['id']?.toString(),
          userId: addressData['user_id']?.toString(),
          address: AddressModel.fromJson(addressData),
          shippingMethodId: orderData['shippingMethod']?.toString() ?? '',
          paymentMethod: orderData['paymentMethod']?.toString() ?? '',
          orderTotal: total,
          promotionId: promotionId,
          notes: orderData['notes']?.toString(),
          shippingFee: deliveryFee,
          discountAmount: discount,
          orderStatus: orderData['status']?.toString(),
          orderDate: orderData['orderDate'] != null
              ? DateTime.parse(orderData['orderDate'].toString())
              : null,
          deliveryCompletedAt: orderData['deliveryCompleted'] != null
              ? DateTime.parse(orderData['deliveryCompleted'].toString())
              : null,
          items: orderItems,
        );

        print("Đã tạo thành công orderModel");
        return orderModel;
      } catch (e, stackTrace) {
        print("Lỗi chi tiết: $e");
        print("Stack trace: $stackTrace");
        throw Exception('Lỗi khi phân tích dữ liệu đơn hàng: $e');
      }
    } else {
      throw Exception('Không thể tải đơn hàng: ${response.statusMessage}');
    }
  }

  @override
  Future<List<OrderModel>> fetchAllOrder() async {
    try {
      print("------- Đang gọi API để fetch all orders - Admin");
      final response = await dio.get('/admin/orders/');

      print("Trạng thái: ${response.statusCode}");
      final code = response.statusCode;

      if (code == 200) {
        final data = response.data;

        if (data is List) {
          final orders = data
              .map((orderJson) {
                try {
                  return OrderModel.fromJson(orderJson);
                } catch (e) {
                  print("Lỗi khi parse OrderModel: $e");
                  return null;
                }
              })
              .whereType<OrderModel>()
              .toList();

          return orders;
        } else {
          throw Exception("Dữ liệu trả về không phải dạng danh sách");
        }
      } else {
        throw Exception("Lỗi khi gọi API: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Lỗi khi fetchAllOrder: $e\n$stackTrace");
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getListOrder() async {
    try {
      print("Đang get dữ liệu toàn bộ order của user cụ thể...");

      final response = await dio.get('/orders');

      debugPrint("GET ALL ORDER: STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data;
        print("RAW DATA:\n${data[1]}");

         //   print("RAW DATA:\n${data[1]['items']}");


        if (data is List) {
          final orders = data
              .map((orderJson) {
                try {
                  return OrderModel.fromJson(orderJson);
                } catch (e) {
                  print("Lỗi khi parse OrderModel: $e");
                  print("JSON gây lỗi: $orderJson"); // log chi tiết lỗi
                  return null;
                }
              })
              .whereType<OrderModel>()
              .toList();

          debugPrint("Tổng số đơn parse thành công: ${orders.length}");
          return orders;
        } else {
          throw Exception("API trả về không phải List");
        }
      } else {
        throw Exception("Lỗi khi gọi API: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Lỗi khi fetchAllOrder: $e\n$stackTrace");
      rethrow;
    }

    //throw Exception("Không thể lấy danh sách đơn hàng.");
  }

  @override
  Future<bool> updateOrder(String orderID,  Map<String, dynamic> updateData) async {
    try {
      final response = await dio.put('/orders/$orderID', data: updateData); 
      print(response.statusCode); 
      if (response.statusCode == 200) {
        return true; 
      }
      else {
        return false; 
      }
    }
    catch (e, stackTrace) {
      print(" Lỗi khi cập nhật order: $e\n$stackTrace");
      rethrow;
    }
  }
}
