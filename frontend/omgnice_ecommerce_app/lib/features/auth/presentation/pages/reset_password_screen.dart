import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/widgets/success_modal_reset_pw.dart';
import '../widgets/common_screen.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/features/auth/auth_export.dart';
import '../widgets/custom_form_field.dart';
import 'package:omgnice_ecommerce_app/core/utils/validators/input_validators.dart';
import '../../../../core/widgets/button.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    String title = 'Reset Password';
    String subtitle = 'Please Enter Your New Password';

    Widget middleWidget = Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email input field
            CustomFormField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
              onSaved: (value) => authProvider.setPassword(value ?? ''),
              errorText: authProvider.errorPasswordText,
              prefixIcon: Icons.lock_outline,
              validator: (value) => InputValidator.validatePassword(value!),
            ),
            CustomFormField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmPasswordController,
              onSaved: (value) => authProvider.confirmPassword = value ?? '',
              errorText: authProvider.errorConfirmPasswordText,
              prefixIcon: Icons.lock,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null; // No error if passwords match
              },
            ),
            const SizedBox(height: 16),
            // Add a "Send Request" button or another action here if needed
            Button(
              oke: true,
              textButton: 'Confirm',
              handleButton: () async {
                // Goi ham cap nhat password trong AuthProvider
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                print(authProvider.email);
                print(_passwordController.text);
                await authProvider.resetPassword(
                    authProvider.email, _passwordController.text);

                if (authProvider.isSuccess) {
                  // TODO: Hien thi DiaLog Thanh cong
                  await showModal(
                      context: context,
                      configuration: const FadeScaleTransitionConfiguration(
                        barrierDismissible:
                            false, // Vo hieu hoa vùng bên ngoài tab
                      ),
                      builder: (context) => SuccessModalResetPw());
                  // TODO: Chuyen sang trang login
                }
              },
            )
          ],
        ),
        // Show the loading card while the operation is in progress
      ],
    );
    return Stack(children: [
      CommonScreen(
        middleWidget: middleWidget,
        title: title,
        subtitle: subtitle,
      ),

      // Loading
      Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isLoading
              ? Positioned.fill(
                  child: Stack(
                    children: [
                      //  Blur nền mờ nhẹ
                      Container(
                        color: Colors.black.withOpacity(0.8), // mờ nhẹ nền
                      ),

                      //  Spinner rõ nét ở giữa
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CustomLoading()),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink();
        },
      )
    ]);
  }
}
