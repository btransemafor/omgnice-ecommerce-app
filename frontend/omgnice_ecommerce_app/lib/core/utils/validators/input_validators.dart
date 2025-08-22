import 'package:omgnice_ecommerce_app/core/utils/extensions.dart';

class InputValidator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required!';
    } else if (!value.isValidEmail) {
      return 'Invalid Email';
    }
    return null;
  }

  static String? validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username is required';
    } else if (value.length < 4) {
      return 'Username must be at least 4 characters';
    } else if (!RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }

    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain at least:\n'
          '- 1 uppercase letter\n'
          '- 1 lowercase letter\n'
          '- 1 number\n'
          '- 1 special character\n'
          '- and be at least 8 characters';
    }

    return null;
  }

  static String? validatePhone(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    }
    if (!value.isValidPhone) {
      return 'Invalid phone number';
    }
    return null;
  }

static Map<String, bool> checkPasswordRequirements(String value) {
  return {
    'hasUppercase': value.contains(RegExp(r'[A-Z]')),
    'hasLowercase': value.contains(RegExp(r'[a-z]')),
    'hasDigits': value.contains(RegExp(r'[0-9]')),
    'hasSpecialChars': value.contains(RegExp(r'[@$!%*?&]')),
    'hasMinLength': value.length >= 8,
  };

} 



  // Validator đơn giản cho đăng nhập
  static String? validateLoginPassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    // Không validate format cho login vì user đã có account
    return null;
  }

  // Validator linh hoạt - chỉ validate khi đủ điều kiện
  static String? validatePasswordOnType(String value) {
    if (value.isEmpty) {
      return null; // Cho phép empty khi đang nhập
    }
    
    // Chỉ validate khi user đã nhập ít nhất 8 ký tự
    if (value.length < 8) {
      return null; // Không hiển thị lỗi khi đang nhập
    }
    
    // Validate đầy đủ khi đã nhập đủ 8 ký tự
    return validatePassword(value);
  }
}
