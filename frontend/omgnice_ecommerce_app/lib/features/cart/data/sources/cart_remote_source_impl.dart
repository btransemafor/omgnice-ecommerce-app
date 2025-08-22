import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/core/services/token_manager.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:dio/dio.dart';
import 'package:omgnice_ecommerce_app/core/constants/url.dart';

abstract class CartRemoteSource {
  Future<List<CartItemModel>> getCart();
  Future<bool> deleteCartItem(int cartItemID);
  Future<bool> addCartItem(
      String? variant_name, int? quantity, String? note, int? product_id);

  Future<bool> updateCartItem(Map<String, dynamic> updateData, int cartItemId);
}

class CartRemoteSourceImpl implements CartRemoteSource {
  final Dio dio = DioClient().client;

  @override
  Future<List<CartItemModel>> getCart() async {
    final ACCESS_TOKEN = await TokenManager.getAccessToken();

    try {
      final response = await dio.get(
        '/carts', 
      );

      //  In toàn bộ dữ liệu trả về từ API để kiểm tra
      print(' API Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];

        //  Kiểm tra nếu `data` là `Map` và chứa `cart_items`
        if (data is Map<String, dynamic> && data.containsKey('cart_items')) {
          final carts = data['cart_items'];

          //  Kiểm tra nếu `cart_items` là một `List`
          if (carts is List) {
            final List<CartItemModel> cartItems =
                carts.map((json) => CartItemModel.fromJson(json)).toList();

            // ignore: avoid_print
            print(
                'Parsed Cart Items: ${cartItems.map((e) => e.toJson()).toList()}');
            return cartItems;
          } else {
            throw Exception('Invalid data format: `cart_items` is not a List.');
          }
        } else {
          throw Exception('Invalid response structure: Missing `cart_items`.');
        }
      } else {
        throw Exception('Invalid response status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data ?? e.message}');
      throw Exception(
        "Get categories failed: ${e.response?.data["message"] ?? e.message}",
      );
    } catch (e) {
      print('❌ Error: $e');
      throw Exception("Failed to load cart items: $e");
    }
  }

  @override
  Future<bool> deleteCartItem(int cartItemId) async {
    final ACCESS_TOKEN = await TokenManager.getAccessToken();
    try {
      print('🔗 Deleting cart item with ID: $cartItemId');

      final response = await dio.delete(
        '/carts/$cartItemId',
      );

      // Kiểm tra phản hồi từ API
      if (response.statusCode == 200) {
        final data = response.data;
        print('📝 Response from API: $data');

        // Kiểm tra nếu response có chứa success: true
        if (data is Map<String, dynamic> && data['success'] == true) {
          print('Item deleted successfully.');
          return true;
        } else {
          throw Exception('API response indicates failure: $data');
        }
      } else {
        throw Exception('Invalid response status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data ?? e.message}');
      throw Exception(
        "Delete item failed: ${e.response?.data["message"] ?? e.message}",
      );
    } catch (e) {
      print('❌ Error: $e');
      throw Exception("Failed to delete cart item: $e");
    }
  }

  // --------------------- Add to Cart ---------------------- //

  Future<bool> addCartItem(String? variant_name, int? quantity, String? note,
      int? product_id) async {
    final ACCESS_TOKEN = await TokenManager.getAccessToken();
    try {
      final response = await dio.post(
        '/carts/',
        data: {
          "product_id": product_id,
          "variant_name": variant_name,
          "quantity": quantity,
          "note": note
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $ACCESS_TOKEN",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //  Kiểm tra xem phản hồi có đúng định dạng JSON không
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;

          if (data.containsKey("success") && data["success"] == true) {
            print(data["message"] ?? "Thêm sản phẩm thành công.");
            return true; //  Thành công
          } else {
            print(data["message"] ?? "Thêm sản phẩm thất bại.");
            return false; // Lỗi API trả về thất bại
          }
        } else {
          print("Lỗi: Phản hồi không phải là JSON.");
          return false;
        }
      } else {
        print("Lỗi: ${response.statusMessage}");
        return false;
      }
    } on DioException catch (e) {
      //  Xử lý lỗi Dio cụ thể
      if (e.response != null) {
        print("DioException: ${e.response?.data["message"] ?? e.message}");
      } else {
        print("Lỗi không có phản hồi từ server: ${e.message}");
      }
      return false;
    } catch (e) {
      //  Bắt tất cả các lỗi khác
      print("Lỗi không mong muốn: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateCartItem(
      Map<String, dynamic> updateData, int cartItemId) async {
    final ACCESS_TOKEN = await TokenManager.getAccessToken();
    try {
      final response = await dio.put(
        '/carts/$cartItemId',
        data: updateData, // Không cần jsonEncode()
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Cập nhật thành công: ${response.data}");
        return true;
      } else {
        print("Cập nhật thất bại với mã lỗi: ${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("DioException: ${e.response?.data["message"] ?? e.message}");
      } else {
        print("Lỗi không có phản hồi từ server: ${e.message}");
      }
      return false;
    } catch (e) {
      print("Lỗi không mong muốn: ${e.toString()}");
      return false;
    }
  }
}
