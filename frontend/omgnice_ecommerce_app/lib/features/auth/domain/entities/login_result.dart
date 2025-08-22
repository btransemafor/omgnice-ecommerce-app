// lib/features/auth/domain/entities/login_result.dart

import 'package:omgnice_ecommerce_app/features/auth/data/models/user_model.dart';


enum LoginStatus { success, failed, requireVerification }

class LoginResult {
  final LoginStatus status;
  final UserModel? user;

  LoginResult(this.status, [this.user]);
}
