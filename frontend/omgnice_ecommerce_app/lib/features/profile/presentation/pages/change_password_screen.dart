import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/validators/input_validators.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/auth/auth_export.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/widgets/custom_form_field.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/widgets/success_modal_reset_pw.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmNewPW = TextEditingController();

  // Focus
  final FocusNode _currentPWFocus = FocusNode();
  final FocusNode _newPWFocus = FocusNode();
  final FocusNode _confirmNewPWFocus = FocusNode();

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmNewPW.dispose();
    _currentPWFocus.dispose();
    _newPWFocus.dispose();
    _confirmNewPWFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BeautifulAppBar(title: 'Reset Password', gradient: true,),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reset Password",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 15),
                  CustomFormField(
                    obscureText: true,
                    hintText: 'Current Password',
                    controller: _currentPassword,
                    prefixIcon: Icons.lock,
                    focus: _currentPWFocus,
                    nextFocus: _newPWFocus,
                    inputAction: TextInputAction.next,
                    validator: (value) =>
                        InputValidator.validatePassword(value!),
                    onSaved: (value) => _currentPassword.text = value!,
                  ),
                  CustomFormField(
                    obscureText: true,
                    hintText: 'New Password',
                    controller: _newPassword,
                    prefixIcon: Icons.lock,
                    focus: _newPWFocus,
                    nextFocus: _confirmNewPWFocus,
                    inputAction: TextInputAction.next,
                    validator: (value) =>
                        InputValidator.validatePassword(value!),
                    onSaved: (value) => _newPassword.text = value!,
                  ),
                  CustomFormField(
                    obscureText: true,
                    hintText: 'Confirm New Password',
                    controller: _confirmNewPW,
                    prefixIcon: Icons.lock,
                    focus: _confirmNewPWFocus,
                    validator: (value) =>
                        InputValidator.validatePassword(value!),
                    onSaved: (value) => _confirmNewPW.text = value!,
                  ),
                  const SizedBox(height: 20),
                  Button(
                    oke: false,
                    textButton: 'Complete',
                    handleButton: () async {
                      // Bắt đầu loading
  
                      final provider =
                          Provider.of<AuthProvider>(context, listen: false);
                          //provider.setLoading(true);
                      final isValid =
                          await provider.checkPassword(_currentPassword.text);

                      if (!isValid) {
                        ErrorHelper.showError(
                            context, 'Current Password Incorrect');
                        return;
                      }

                      final result = await provider.resetPasswordUsecase(
                          '', _newPassword.text);

                      if (result) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            //  Gọi logout và chờ hoàn tất
                            Provider.of<AuthProvider>(context, listen: false)
                                .logout();
                            // Reset về tab 0 trướ khi về trang login
                            Provider.of<ScreenManager>(context, listen: false)
                                .goToHome();
                            return SuccessModalResetPw(); // Modal thông báo thành công
                          },
                        );
                      } else {
                        ErrorHelper.showError(
                            context, "Failed to reset password.");
                      }
                    },
                  ),
                ],
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return (authProvider.isLoading)
                    ? Center(child: CustomLoading())
                    : SizedBox.shrink(); // Show loading or nothing
              },
            )
          ],
        ),
      ),
    );
  }
}
