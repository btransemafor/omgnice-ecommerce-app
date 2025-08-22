// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'auth_interceptor.dart';

class DioClient {
  /// Singleton pattern: đảm bảo Dio chỉ khởi tạo 1 lần duy nhất trong toàn bộ app
  static final DioClient _instance = DioClient._internal();

  late Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    // Base configuration cho mọi request
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://YOUR_IP:8081/api', //  Đặt base URL tại đây
       // connectTimeout: const Duration(seconds: 2), //  Thời gian chờ kết nối server 
       // receiveTimeout: const Duration(seconds: 2), //  Thời gian chờ nhận dữ liệu từ server
        sendTimeout: const Duration(seconds: 60), // ⏱ Thời gian gửi data (nếu dùng POST)
        contentType: 'application/json', //  Loại nội dung mặc định cho mọi request
        responseType: ResponseType.json, //  Dự đoán server trả về JSON
      ),
    );

    //  Thêm Interceptor để xử lý token, log, v.v.
    _dio.interceptors.add(AuthInterceptor(_dio));

    //  LogInterceptor nếu cần debug response chi tiết
    // _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  /// Getter để lấy Dio đã config
  Dio get client => _dio;
}
