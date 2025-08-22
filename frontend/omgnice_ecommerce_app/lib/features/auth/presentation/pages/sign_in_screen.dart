import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/sign_in_form.dart';
import '../provider/auth_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  void _goToVerification(BuildContext context, VerificationFlow flow) {
    context.pushNamed(
      'verify',
      extra: flow, // enum VerificationFlow
    );
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final LoginStatus status = await authProvider.signInWithGoogle();
    final screenProvider = Provider.of<ScreenManager>(context, listen: false);
    switch (status) {
      case LoginStatus.success:
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadUser(); // Quan trọng: thêm await!

        final user = userProvider.userInfo;

        if (user != null) {
          if (!user.isActive) {
            ErrorHelper.showError(
              context,
              'Your account has been locked. \n Please contact the administrator.',
            );
            print('Your account is locked. Please contact the administrator.');
            return;
          }

          int? role = user.roleId;
          print('ROLE in login: $role');

          if (role == 2) {
            print('Navigating to Admin Dashboard');
            screenProvider.goToHome();
            
            context.goNamed('adminHomeScreen');
          } else {
            print('Navigating to User Home');
            //
            SuccessHelper.showSuccess(context, 'Đăng nhập thành công.');
            screenProvider.goToHome();
            context.goNamed('home');
          }
        }
        break;

      case LoginStatus.requireVerification:
        _goToVerification(context, VerificationFlow.loginUnverified);
        break;

      case LoginStatus.failed:
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đăng nhập thất bại. Vui lòng thử lại."),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final greenColor = const Color(0xFF699D3C);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: greenColor,
                expandedHeight: size.height * 0.25,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: greenColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png',
                            width: size.height * 0.20,
                            height: size.height * 0.20),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.white, Colors.green.shade200],
                          ).createShader(bounds),
                          child: Text(
                            'OMGNICE',
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: size.height,
                  color: greenColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcomeHeader(size, greenColor),
                            const SizedBox(height: 5),
                            Text("Please login to continue",
                                style: GoogleFonts.poppins(
                                    fontSize: size.width * 0.0355,
                                    color: Colors.grey)),
                            const SignInForm(),
                            const SizedBox(height: 10),
                            _buildDividerWithText("Or"),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => handleGoogleSignIn(context),
                              child: _buildGoogleButton(size),
                            ),
                            const SizedBox(height: 10),
                            //GestureDetector(child: _buildPhoneButton(size)),
                            Align(
                                alignment: Alignment.center,
                                child: _buildSignUpRow(context, size)),
                            // ---  phần Contact Support ---
                            const SizedBox(height: 1),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                  onTap: () {
                                    showMyBottomSheet(context);
                                  },
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.support_agent,
                                            color: greenColor),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Need help?',
                                          style: GoogleFonts.poppins(
                                            fontSize: size.width * 0.032,
                                            color: greenColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ])),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //  Lớp loading mờ
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isLoading
                  ? Positioned.fill(
                      child: Stack(
                        children: [
                          //  Layer blur
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),

                          //  Loading
                          Container(
                            alignment: Alignment.center,
                            color: Colors.black.withOpacity(0.1),
                            child: const CustomLoading(),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(Size size, Color greenColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome back!",
            style: GoogleFonts.poppins(
                fontSize: size.width * 0.055, fontWeight: FontWeight.w700)),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            color: greenColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildDividerWithText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(text, style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          const Expanded(child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGoogleButton(Size size) {
    return _buildAuthButton(
      icon: Image.asset('assets/logo_google.png', height: 24),
      text: "Continue With Google",
      fontSize: size.width * 0.035,
    );
  }

  Widget _buildPhoneButton(Size size) {
    return _buildAuthButton(
      icon: const Icon(Icons.phone_outlined, color: Colors.green),
      text: "Continue With Phone",
      fontSize: size.width * 0.035,
    );
  }

  Widget _buildAuthButton(
      {required Widget icon, required String text, required double fontSize}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(text,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget _buildSignUpRow(BuildContext context, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?",
            style: GoogleFonts.poppins(
                fontSize: size.width * 0.0355, color: Colors.black)),
        TextButton(
          onPressed: () {
            (context).goNamed('signUp');
            Provider.of<AuthProvider>(context, listen: false).reset();
          },
          child: Text("Sign Up",
              style: GoogleFonts.poppins(
                  fontSize: size.width * 0.0355, color: Colors.green)),
        ),
      ],
    );
  }

  void showMyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // Title with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.contact_support_rounded,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Choose Contact Method',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Select how you would like to contact us',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Email Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[400]!, Colors.green[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    launchUrl(Uri.parse('mailto:omgnicesupport@gmail.com'));
                    Navigator.of(context).pop();
                    // Xử lý Email
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.email_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Contact via Email',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    launchUrl(Uri.parse('tel:+84338498406'));

                    /*  launchUrl(Uri.parse(
                                        'mailto:omgnicesupport@gmail.com')); */

                    Navigator.of(context).pop();
                    // Xử lý Phone
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.phone_rounded,
                        color: Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Contact via Phone',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Cancel button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              // Bottom padding for safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onConfirm;

  const MyBottomSheet({
    Key? key,
    required this.title,
    required this.content,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity, // full chiều rộng
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            ),
          ],
        ),
        child: Wrap(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            content,
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (onConfirm != null) onConfirm!();
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
