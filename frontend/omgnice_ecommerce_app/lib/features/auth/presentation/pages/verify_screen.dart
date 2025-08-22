import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/features/auth/auth_export.dart';
import '../provider/auth_provider.dart';
import 'package:pinput/pinput.dart';
import '../provider/otp_countdown_provider.dart';
import 'package:flutter/gestures.dart';
import '../../../../core/widgets/button.dart';
import '../widgets/otp_countdown_text.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatefulWidget {
  final VerificationFlow flow;
  const VerifyScreen({Key? key, required this.flow}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _pinputFocusNode = FocusNode();

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final otpCountdownProvider =
          Provider.of<OtpCountdownProvider>(context, listen: false);
      otpCountdownProvider.startCountdown();

      final userProvider =
          Provider.of<UserProvider>(context, listen: false);

      // Load user asynchronously and log result
      userProvider.loadUser().then((_) {
        print('InitState: Loaded user: ${userProvider.userInfo?.pwRandom}');
      }).catchError((e) {
        print('InitState: Error loading user: $e');
      });

      _pinputFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _pinputFocusNode.dispose();
    super.dispose();
  }

 /*  void handleVerifyOTPSuccess(BuildContext context) async {
     final userProvider = Provider.of<UserProvider>(context, listen: false);
     await userProvider.loadUser(); // Wait for loadUser to complete
      final pwRandom = userProvider.userInfo?.pwRandom ?? '';
      print('handleVerifyOTPSuccess: pwRandom = $pwRandom');

    switch (widget.flow) {
      case VerificationFlow.register:
      case VerificationFlow.loginUnverified:

       if (pwRandom.isNotEmpty) {
            context.goNamed('randomPassword', extra: pwRandom);
          }
          break;
      // Get pw


      case VerificationFlow.forgotPassword:
        context.goNamed('setNewPassword');
        break;
    }
  } */

  Future<void> handleVerifyOTPSuccess(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.loadUser(); // Wait for loadUser to complete
      final pwRandom = userProvider.userInfo?.pwRandom ?? '';
      print('handleVerifyOTPSuccess: pwRandom = $pwRandom');

      switch (widget.flow) {
        case VerificationFlow.register:
        case VerificationFlow.loginUnverified:
          if (pwRandom.isNotEmpty) {
            context.goNamed('randomPassword', extra: pwRandom);
          } else {
            ErrorHelper.showError(context, 'Failed to retrieve random password. Please try again.');
          }
          break;
        case VerificationFlow.forgotPassword:
          context.goNamed('setNewPassword');
          break;
      }
    } catch (e) {
      print('Error in handleVerifyOTPSuccess: $e');
      ErrorHelper.showError(context, 'Failed to load user data. Please try again.');
    }
  }

  void handleVerifyOTP(
      BuildContext context, AuthProvider authProvider, String otp) async {
    await authProvider.verifyOTP(authProvider.email, otp);
    if (authProvider.isVerifySuccess!) {
      handleVerifyOTPSuccess(context);
    } else {
      ErrorHelper.showError(context, 'OTP verification failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final otpCountdownProvider = Provider.of<OtpCountdownProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFF699D3C),
                expandedHeight: size.height * 0.25,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: const Color(0xFF699D3C),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png',
                            width: size.height * 0.20),
                        Text(
                          'OMGNICE',
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
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
                  color: Colors.green,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "OTP Verification",
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.055,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return Text(
                                "Enter the OTP code sent to your email: ${authProvider.email}",
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.04,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          const OtpCountdownText(),
                          const SizedBox(height: 20),
                          Pinput(
                            controller: _otpController,
                            focusNode: _pinputFocusNode,
                            length: 6,
                            keyboardType: TextInputType.number,
                            showCursor: true,
                            onCompleted: (pin) =>
                                handleVerifyOTP(context, authProvider, pin),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            defaultPinTheme: PinTheme(
                              width: 50,
                              height: 50,
                              textStyle:
                                  TextStyle(fontSize: 20, color: Colors.green),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Didn't receive OTP? ",
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.04,
                                  color: Colors.grey,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Resend",
                                    style: TextStyle(
                                      color: otpCountdownProvider.canResend
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = otpCountdownProvider.canResend
                                          ? () {
                                              otpCountdownProvider
                                                  .startCountdown();
                                              authProvider.resendOTPVerify(
                                                  authProvider.email);
                                            }
                                          : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Button(
                            oke: true,
                            textButton: 'Verify',
                            handleButton: () {
                              final otp = _otpController.text.trim();
                              handleVerifyOTP(context, authProvider, otp);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.isLoading
                ? Positioned.fill(
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
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
      ]),
    );
  }
}
 


