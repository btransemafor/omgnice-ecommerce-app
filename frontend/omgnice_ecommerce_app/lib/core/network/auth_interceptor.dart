/*

Tự động gắn Access Token vào mọi request.
Khi Access Token hết hạn (lỗi 401), dùng Refresh Token để lấy lại Access Token mới.
Giữ lại các request đang bị chặn và retry sau khi token được làm mới thành công.

*/
import 'package:dio/dio.dart';
import 'token_manager.dart';
class AuthInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final List<Function()> _queue = [];

  AuthInterceptor(this.dio);

@override
Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
  print("Interceptor: đang lấy token");
  final token = await TokenManager.getAccessToken();
  
  if (token != null) {
    String tokenPreview = token.length > 10 ? "${token.substring(0, 10)}..." : token;
    print("Interceptor: token = $tokenPreview");
    
    options.headers['Authorization'] = 'Bearer $token';
    print("Interceptor: đã thêm token vào headers");
  } else {
    print("Interceptor: không có token");
  }
  
  return handler.next(options);
}
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && TokenManager.refreshToken != null) {
      // Đang refresh token thì thêm request vào hàng đợi
      if (_isRefreshing) {
        _queue.add(() async {
          final cloneReq = await _retryRequest(err.requestOptions);
          handler.resolve(cloneReq);
        });
        return;
      }

      _isRefreshing = true;

      try {
        await _refreshToken(); // gọi refresh
        _isRefreshing = false;

        // chạy lại các request trong queue
        for (final callback in _queue) {
          await callback();
        }
        _queue.clear();

        final cloneReq = await _retryRequest(err.requestOptions);
        handler.resolve(cloneReq);
      } catch (e) {
        _isRefreshing = false;
        _queue.clear();
        await TokenManager.clear();
        handler.reject(err);
      }
    } else {
      handler.next(err);
    }
  }
Future<void> _refreshToken() async {
  final refreshToken =  await TokenManager.getRefreshToken(); 
  if (refreshToken == null) throw Exception('No refresh token');

  final response = await dio.post('/refresh-token', data: {
    'refreshToken': refreshToken,
  });

  final data = response.data;
  final newAccess = data['accessToken'];
  final newRefresh = data['refreshToken'];

  if (newAccess != null && newRefresh != null) {
    await TokenManager.saveTokens(newAccess, newRefresh);
  } else {
    throw Exception('Invalid refresh response');
  }
}

  Future<Response> _retryRequest(RequestOptions requestOptions) {
    final token = TokenManager.accessToken;
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $token',
      },
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
