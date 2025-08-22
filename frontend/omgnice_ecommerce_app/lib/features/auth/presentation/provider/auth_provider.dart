import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/provider/user_provider.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/check_password_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/logout_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/register_user_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/resend_otp_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/reset_password_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/signin_google_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/verify_otp_usecase.dart';
import '../../domain/usecase/login_user_usecase.dart';
import 'package:omgnice_ecommerce_app/core/utils/validators/input_validators.dart';

enum LoginStatus { success, requireVerification, failed }

enum VerificationType { registration, passwordReset }

class AuthProvider extends ChangeNotifier {
  final LoginUserUseCase loginuserUC;
  final RegisterUserUseCase registerUserUC;
  final VerifyOTPUseCase verifyOTPUseCase;
  final ResendOtpUsecase resendOtpUsecase;
  final LogoutUsecase logoutUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final SigninGoogleUsecase signinGoogleUsecase;
  final CheckPasswordUsecase checkPasswordUsecase;
  AuthProvider({
    required this.loginuserUC,
    required this.registerUserUC,
    required this.verifyOTPUseCase,
    required this.resendOtpUsecase,
    required this.forgotPasswordUsecase,
    required this.logoutUsecase,
    required this.resetPasswordUsecase,
    required this.signinGoogleUsecase,
    required this.checkPasswordUsecase,
  });


  String? token;
  bool isSuccess = false;
  bool isLoading = false;
  String? errorMessage;

  bool? isRegisterSuccess = false;
  bool? isVerifySuccess;
  bool? isResend;

  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  bool? isChecked = false;

  // ========================================================
  // ===================== Form Validation ==================
  // ========================================================

  String? _errorEmailText;
  String? _errorPasswordText;
  String? _errorPhoneText;
  String? _errorUsernameText;
  String? _errorConfirmPasswordText;

  String? get errorEmailText => _errorEmailText;

  String? get errorPasswordText => _errorPasswordText;

  String? get errorPhoneText => _errorPhoneText;

  String? get errorUsernameText => _errorUsernameText;

  String? get errorConfirmPasswordText => _errorConfirmPasswordText;

  bool initCheck = false;

  LoginStatus _status = LoginStatus.failed;
  LoginStatus get status => _status;

  Future<LoginStatus> signInWithGoogle() async {
    isLoading = true;
    isSuccess = false;
    LoginStatus status = LoginStatus.failed;
    notifyListeners();
    try {
      final result = await signinGoogleUsecase.call();

      if (result != null) {
        if (result.active == true) {
          status = LoginStatus.success;
          isSuccess = true;
        } else {
          status = LoginStatus.requireVerification;
          setEmail(result.email!);
        }
      }
    } catch (error, stacktrace) {
      errorMessage = "Login Failed";
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }

    _status = status;
    return status;
  }

  void reset() {
    email = '';
    password = '';
    //phone = '';
    initCheck = true;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    _validateEmail(value);
  }

  void setPhone(String value) {
    phone = value;
    _validatePhone(value);
  }

  void setPassword(String value) {
    password = value;
    _validatePassword(value);
  }

  void validateConfirmPassword() {
    _errorConfirmPasswordText =
        confirmPassword != password ? 'Passwords do not match' : null;
    notifyListeners();
  }

  // ===================== Helper Methods ===================
  Future<void> _performActionWithLoading(Future<void> Function() action) async {
    try {
      isLoading = true;
      notifyListeners();
      await action();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // ======================= LOGIN =========================

  // Ham login de tra ve trang thai
  Future<LoginStatus> _login(
    String identifier,
    String password,
    Future<LoginStatus> Function(String, String) loginFunction,
  ) async {
    LoginStatus result = LoginStatus.failed;

    await _performActionWithLoading(() async {
      errorMessage = null; // Reset trước
      try {
        final loginResult = await loginFunction(identifier, password);
        result = loginResult;
        isSuccess = result == LoginStatus.success;
        //   print("__________ ${result} _________________");
      } catch (error, stacktrace) {
        //  print('Login error: $error');
        isSuccess = false;
        errorMessage = error.toString();
        result = LoginStatus.failed;
      }
    });

    return result;
  }

  Future<LoginStatus> loginWithEmail(String email, String password) async {
    return await _login(email, password, loginuserUC.loginWithEmail);
  }

  Future<void> logout() async {
    await _performActionWithLoading(() async {
      await Future.delayed(Duration(seconds: 2));
      await logoutUsecase.call();
      isSuccess = false;
      notifyListeners();
    });
  }

  // ======================= REGISTER =======================
  Future<void> register(String email, String phone, String password) async {
    await _performActionWithLoading(() async {
      isRegisterSuccess = await registerUserUC.register(email, phone, password);
      if (isRegisterSuccess == false) {
        errorMessage = "Email or phone already exists.";
      }
      notifyListeners();
    });
  }

  // ======================= VERIFY OTP ====================

  bool isPasswordReset = false;
  late VerificationType previousScreen;
  void setVericationType(VerificationType type) {
    previousScreen = type;
    notifyListeners();
  }

  Future<void> verifyOTP(String email, String otp) async {
    isVerifySuccess = false;

    await _performActionWithLoading(() async {
      final result = await verifyOTPUseCase.verifyOTP(email, otp);

      isVerifySuccess = result;

      if (!result) {
        print("Verify OTP thất bại");
        return;
      }
    });

    notifyListeners();
  }

  // ======================= RESEND OTP ====================
  Future<void> resendOTPVerify(String email) async {
    await _performActionWithLoading(() async {
      isResend = await resendOtpUsecase.resendOTPVerify(email);
      if (isResend == true) {
        print("Resend OTP Successful");
      }
    });
  }

  // ===================== Form Validation ==================
  bool validateSignInForm(GlobalKey<FormState> key) {
    final isValid = key.currentState?.validate() ?? false;
    if (isValid) key.currentState?.save();
    return isValid;
  }

  bool validateSignUpForm(GlobalKey<FormState> key) {
    final isValid = key.currentState?.validate() ?? false;
    if (isValid) key.currentState?.save();
    return isValid;
  }

  void _validateEmail(String value) {
    _errorEmailText = InputValidator.validateEmail(value);
    notifyListeners();
  }

  void _validatePhone(String value) {
    _errorPhoneText = InputValidator.validatePhone(value);
    notifyListeners();
  }

  void _validatePassword(String value) {
    _errorPasswordText = InputValidator.validatePassword(value);
    notifyListeners();
  }

  void clearToken() {
    token = null;
    isSuccess = false;
    //await localSource.clearToken();
    notifyListeners();
  }

  bool? isForPasswordReset;
  bool? isForRegistration;

  Future<void> forgotPassword(String email) async {
    await _performActionWithLoading(() async {
      isForPasswordReset = await forgotPasswordUsecase.forgotPassword(email);
      if (isForPasswordReset == true) {
        print("Request Forgot Password OTP Successful");
      } else {
        print("Request Forgot Password OTP Failed");
      }

      notifyListeners();
    });
  }

  bool? light = false;
  void checkbox(bool value) {
    light = value;
    notifyListeners();
  }

// Reset Password
  Future<void> resetPassword(String? email, String newPassword) async {
    isLoading = true;
    notifyListeners();
    isSuccess = false;

    try {
      isSuccess = await resetPasswordUsecase.call(email, newPassword);

      if (isSuccess) {
        errorMessage = null;
      }
    } catch (error) {
      errorMessage = 'Reset Password Failed';
      isSuccess = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// Check password
  bool isCheck = false;
  Future<bool> checkPassword(String currentPassword) async {
    try {
      isCheck = await checkPasswordUsecase.call(currentPassword);
    } catch (error) {
      isCheck = false;
    } finally {
      notifyListeners();
    }

    return isCheck;
  }
}
