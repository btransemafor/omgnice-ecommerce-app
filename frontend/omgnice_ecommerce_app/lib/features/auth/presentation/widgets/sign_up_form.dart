import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_form_field.dart';
import '../provider/auth_provider.dart';
import '../../../../core/utils/helpers/error_helper.dart';
import '../../../../core/utils/validators/input_validators.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/widgets/passwordRequirement.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigits = false;
  bool _hasSpecialChars = false;
  bool _hasMinLength = false;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _validatePassword(String? password) {
    if (password == null || password.isEmpty || password == '') {
      setState(() {
        _isEmpty = true;
        _hasUppercase = false;
        _hasLowercase = false;
        _hasDigits = false;
        _hasSpecialChars = false;
        _hasMinLength = false;
      });
      return;
    }

    final requirements = InputValidator.checkPasswordRequirements(password);

    setState(() {
      _isEmpty = false;
      _hasUppercase = requirements['hasUppercase'] ?? false;
      _hasLowercase = requirements['hasLowercase'] ?? false;
      _hasDigits = requirements['hasDigits'] ?? false;
      _hasSpecialChars = requirements['hasSpecialChars'] ?? false;
      _hasMinLength = requirements['hasMinLength'] ?? false;
    });
  }

  bool get _isFormValid {
    return _hasUppercase &&
        _hasLowercase &&
        _hasDigits &&
        _hasSpecialChars &&
        _hasMinLength &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
    // _passwordController.text.isNotEmpty &&
    //_confirmPasswordController.text == _passwordController.text;
  }

  void handleRegister(AuthProvider authProvider, BuildContext context,
      String email, String phone, String password) async {
    try {
      await authProvider.register(email, phone, password);
      authProvider.previousScreen = VerificationType.registration;

      if (authProvider.isRegisterSuccess == true) {
        SuccessHelper.showSuccess(context, "Register Successfully");
        //Navigator.pushReplacementNamed(context, '/verify');
        context.goNamed('verify', extra: VerificationFlow.register);
      } else {
        ErrorHelper.showError(
            context,
            authProvider.errorMessage ??
                'Registration failed. Please try again.');
      }
    } catch (e) {
      ErrorHelper.showError(context, 'Registration failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Form(
        key: _signUpFormKey,
        child: Column(
          children: [
            CustomFormField(
              prefixIcon: Icons.email,
              hintText: 'Email',
              controller: _emailController,
              onSaved: (value) => authProvider.setEmail(value ?? ''),
              onChanged: (value) {
                authProvider.setEmail(value);
              },
              validator: (value) => InputValidator.validateEmail(value!),
            ),
            CustomFormField(
              prefixIcon: Icons.phone,
              hintText: 'Phone',
              controller: _phoneController,
              onSaved: (value) => authProvider.setPhone(value ?? ''),
              validator: (value) => InputValidator.validatePhone(value!),
              onChanged: (value) => InputValidator.validatePhone(value),
            ),
            CustomFormField(
              prefixIcon: Icons.lock_outline,
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
              onSaved: (value) => authProvider.setPassword(value ?? ''),
              onChanged: _validatePassword,
            ),

            // Chỉ hiển thị các yêu cầu mật khẩu khi người dùng bắt đầu nhập
            if (!_isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PasswordRequirement(
                        isValid: _hasLowercase,
                        requirementText: 'At least one lowercase letter'),
                    PasswordRequirement(
                        isValid: _hasUppercase,
                        requirementText: 'At least one uppercase letter'),
                    PasswordRequirement(
                        isValid: _hasDigits,
                        requirementText: 'At least one digit'),
                    PasswordRequirement(
                        isValid: _hasSpecialChars,
                        requirementText: 'At least one special character'),
                    PasswordRequirement(
                        isValid: _hasMinLength,
                        requirementText: 'At least 8 characters long'),
                  ],
                ),
              ),

            CustomFormField(
              prefixIcon: Icons.lock,
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmPasswordController,
              onSaved: (value) => authProvider.confirmPassword = value ?? '',
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Button(
                oke: true,
                textButton: 'Create Account',
                handleButton: _isFormValid
                    ? () async {
                        if (_signUpFormKey.currentState!.validate()) {
                          _signUpFormKey.currentState!.save();

                          handleRegister(
                              authProvider,
                              context,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text);
                        }
                      }
                    : null),
          ],
        ),
      ),
    );
  }
}
