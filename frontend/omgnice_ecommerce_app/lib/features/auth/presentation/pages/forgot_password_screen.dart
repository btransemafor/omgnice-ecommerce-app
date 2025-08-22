import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import '../widgets/common_screen.dart';
import '../../../../core/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/features/auth/auth_export.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    String title = 'Forgot Password';
    String subtitle =
        """Uh-oh, looks like your password took a vacation! OMG no worries, just enter your email and we'll send it back to you in no time!""";

    // TextEditingController _emailController = TextEditingController(); rùi nnguy hiểm nè
    // Khai báo trong build nó sẽ bị reset lại
    Widget middleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _emailController,
          style: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color.fromARGB(255, 114, 111, 111),
          fontWeight: FontWeight.w300,
        ),
          decoration: InputDecoration(
            errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
            labelStyle: GoogleFonts.poppins(fontSize: 12),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            hintText: 'Email',
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            prefixIcon: Icon(Icons.email_outlined, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.018,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Button(
          oke: true,
          textButton: 'Confirm',
          handleButton: () async {
            if (_emailController.text.isEmpty) {
              ErrorHelper.showError(context, "Email is Required!");
            } else {
              print("Đang gửi OTP tới email ${_emailController.text}");
              try {
                await authProvider.forgotPassword(_emailController.text);

                if (!context.mounted) return;

                if (authProvider.isForPasswordReset == true) {
                  authProvider.previousScreen = VerificationType.passwordReset;
                  authProvider.email = _emailController.text;

                  SuccessHelper.showSuccess(context, 'OTP is sent for you!');

                  if (!context.mounted) return;
                  (context).goNamed('verify', extra: VerificationFlow.forgotPassword); 
                } else {
                  ErrorHelper.showError(context, "Failed to send OTP.");
                }
              } catch (e) {
                ErrorHelper.showError(context, "Email Not Existing.");
              }
            }
          },
        )
      ],
    );

    return Stack(
      children: [
        CommonScreen(
          middleWidget: middleWidget,
          title: title,
          subtitle: subtitle,
        ),
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
      ],
    );
  }
}
