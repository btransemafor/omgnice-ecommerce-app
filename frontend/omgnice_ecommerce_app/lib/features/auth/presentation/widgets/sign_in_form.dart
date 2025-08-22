// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/user_provider.dart';
import '../widgets/custom_form_field.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../../../../core/utils/helpers/error_helper.dart';
import "package:omgnice_ecommerce_app/core/utils/validators/input_validators.dart";
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleLogin(AuthProvider authProvider, BuildContext context,
      String email, String password) async {
    try {
      authProvider.setEmail(email);
      final status = await authProvider.loginWithEmail(email, password);
      final screenProvider = Provider.of<ScreenManager>(context, listen: false);
      screenProvider.goToHome();

      switch (status) {
        case LoginStatus.success:
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          await userProvider.loadUser();
          final user = userProvider.userInfo; 
          if (user != null && user.roleId != null) {
            print('User isActive: ${user.isActive}');
            print('User roleId: ${user.roleId}');
            // Check is_active
            if (!user.isActive) {
              print('User account is inactive - showing error');
              ErrorHelper.showError(context,
                  'Your account has been locked. Please contact the administrator.');
              return;
            }
            int? role = user.roleId;
            print('ROLE in login: $role');
            if (role == 2) {
              print('Navigating to Admin Dashboard');
              context.goNamed('adminHomeScreen');
            } else {
              print('Navigating to User Home');
              SuccessHelper.showSuccess(context, 'Login successful.');
              context.goNamed('home');
            }
          } else {
            print('ROLE is null at login success!');
            ErrorHelper.showError(context, 'Cannot determine user role.');
          }
          break;

        case LoginStatus.requireVerification:
          await authProvider.resendOTPVerify(authProvider.email);
          context.goNamed('verify');
          break;

        case LoginStatus.failed:
        default:
          ErrorHelper.showError(context, 'Email or password is incorrect');
          break;
      }
    } catch (e) {
      print('Login error: $e'); 
      ErrorHelper.showError(context, 'Login error. Please try again later');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            hintText: 'Email',
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            validator: (value) => InputValidator.validateEmail(value!),
            onSaved: (value) => _emailController.text = value!,
          ),
          CustomFormField(
            hintText: 'Password',
            obscureText: true,
            controller: _passwordController,
            prefixIcon: Icons.lock_outline,
            onSaved: (value) => _passwordController.text = value!,
           // validator: (value) => InputValidator.validateLoginPassword(value!), 
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Transform.scale(
                    scale: 0.6,
                    child: Switch(
                      value: authProvider.light!,
                      activeColor: Colors.green,
                      onChanged: (value) => authProvider.checkbox(value),
                    ),
                  ),
                  Text(
                    'Remember me',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: size.width * 0.0295,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  (context).pushNamed('forgotPassword');
                },
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: size.width * 0.0295,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Button(
            textButton: authProvider.isLoading ? 'Logging in...' : 'Login',
            oke: true,
            handleButton: () async {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                handleLogin(
                  authProvider,
                  context,
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
