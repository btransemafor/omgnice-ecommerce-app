// ignore_for_file: avoid_print
import 'package:omgnice_ecommerce_app/core/network/token_manager.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/sources/local/auth_local_data_source.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/sources/firebase/google_sign_in_service.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import '../../auth_export.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remoteSource;
  final AuthLocalDataSource localSource;
  final AuthService authService;

  AuthRepositoryImpl(
      {required this.remoteSource,
      required this.localSource,
      required this.authService});

  @override
  Future<LoginStatus> loginWithEmail(String email, String password) async {
    try {
      final LoginResponseModel response =
          await remoteSource.loginWithEmail(email, password);

      final accessToken = response.accessToken;
      final refreshToken = response.refreshToken;
      final UserModel user;
      user = response.user!;

      final requireVerification = response.requireVerification;

      if (requireVerification == true) {
        print("Account requires email verification.");
        return LoginStatus.requireVerification;
      }

      if (accessToken == null || refreshToken == null) {
        throw Exception("Missing token(s) in login response.");
      }
      // lưu token
      await TokenManager.saveTokens(accessToken, refreshToken);
      await localSource.cacheToken(accessToken, refreshToken);
      // Lưu thông tin user
      await localSource.cacheUser(user);

      print(user);

      print("Login successful!");

      return LoginStatus.success;
    } catch (e) {
      print("Login with email failed: $e");
      return LoginStatus.failed;
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    print('DEBUG: Đang gọi dịch vụ Login With Google ');
    final loginResponse = await authService.signInWithGoogle();
    final String? accessToken = loginResponse?.accessToken;
    final String? refreshToken = loginResponse?.refreshToken;
    final UserModel? user;
    user = loginResponse?.user;
    if (accessToken == null || refreshToken == null || user == null) {
      throw Exception("Missing token(s) in login response.");
    }
    // Sau khi đăng nhập thành công thì lưu token
    await TokenManager.saveTokens(accessToken, refreshToken);
    await localSource.cacheToken(accessToken, refreshToken);
    // Lưu thông tin user vào Share Preferences ở Local
    print(user.pwRandom); 
    await localSource.cacheUser(user);

    print(
        '------------------SAVE AccessToken và RefreshToken Successfully!!!!!!-----------');
    print("user.pwRandom: HEHEHHEHEHEHHE${user.pwRandom}");
    return user;
  }

  @override
  Future<bool> checkGoogleEmailExists(String idToken) async {
    return await remoteSource.checkGoogleEmailExists(idToken);
  }

  @override
  Future<bool> register(String email, String phone, String password) async {
    try {
      final checkRegister = await remoteSource.register(email, phone, password);
      return checkRegister;
    } catch (e) {
      throw Exception("Register with email failed: ${e.toString()}");
    }
  }

  // ------------------- Xac thuc OTP ------------------- //
  @override
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      return await remoteSource.verifyOTP(email, otp);
    } catch (error) {
      throw Exception("Verify OTP For New Account Failed");
    }
  }

  // ----------------------- Resend - OTP -------------------- //
  @override
  Future<bool> resendOTPVerify(String email) async {
    try {
      return await remoteSource.resendOTPVerify(email);
    } catch (error) {
      throw Exception("Resend OTP Failed");
    }
  }

  /// ----------------------- Forgot Password ---------------------- //
  @override
  Future<bool> forgotPassword(String email) async {
    return await remoteSource.forgotPassword(email);
  }

  /// ----------------------- Logout ---------------------- //
  @override
  Future<void> logout() async {
    try {
      final refreshToken = await TokenManager.getRefreshToken();

      final accessToken = await TokenManager.getAccessToken();
      print("Access token: $accessToken");

      if (refreshToken == null || accessToken == null) {
        // Có thể đã logout trước đó
        print("Logout without refresh token");
        await TokenManager.clear();
        await localSource.clear(); 

        return;
      }
      print("Logout with refresh token: $refreshToken");

      await remoteSource.logOut(refreshToken);

      await TokenManager.clear();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> resetPassword(String? email, String newPassword) async {
    // Lấy token từ TokenManager thay vì localSource
    final accessToken = await TokenManager.getAccessToken();
    return await remoteSource.resetPassword(email, newPassword);
  }

////// ------------------------------ LOCAL ----------------------------------- ////

  /// 1.0 ------------------ GET CURRENT USER ----------------------- //

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      print('[AuthRepo]  Đang lấy user từ SharedPreferences...');

      final userModel = await localSource.getCachedUser();

      if (userModel == null) {
        throw Exception('Không tìm thấy user trong local storage');
      }

      print('Đã get info user from Local: ${userModel}');

      return UserEntity(
          pwRandom: userModel.pwRandom,
          isActive: userModel.isActive,
          id: userModel.id,
          name: userModel.name,
          phone: userModel.phone,
          email: userModel.email,
          point: userModel.point,
          roleId: userModel.roleId,
          avatar: userModel.avatar);
    } catch (error, stackTrace) {
      print('[AuthRepo]  Lỗi khi getCurrentUser: $error');
      print(stackTrace);
      throw Exception('Không thể lấy dữ liệu user từ Local Storage');
    }
  }

  @override
  Future<bool> checkPassword(String currentPassword) async {
    return await remoteSource.checkPassword(currentPassword);
  }
}
