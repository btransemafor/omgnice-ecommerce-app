import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF699D3C),
              expandedHeight: size.height * 0.25,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: const Color(0xFF699D3C),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with subtle shadow
                      Container(
                        child: Image.asset(
                          'assets/logo.png',
                          width: size.height * 0.20,
                          height: size.height * 0.20,
                        ),
                      ),
                      // const SizedBox(height: 5),
                      // Brand name with gradient text
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.green.shade200,
                          ],
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

            // Main content
            SliverToBoxAdapter(
              child: Stack(children: [
                Container(
                  color: Color(0xFF699D3C),
                  child: Container(
                    height: size.height * 1,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create Account",
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.055,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF699D3C),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Text(
                            "Please create your account to continue",
                            style: GoogleFonts.poppins(
                                fontSize: size.width * 0.0355,
                                color: Colors.grey),
                          ),

                          //const SizedBox(height: 5),
                          // Sign Up Form
                          const SignUpForm(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account ?",
                                  style: GoogleFonts.poppins(
                                      fontSize: size.width * 0.0355,
                                      color: Colors.black)),
                              TextButton(
                                onPressed: () {
                                  // Reset email, password, phone trước khi chuyển màn
                                  final authProvider =
                                      Provider.of<AuthProvider>(context,
                                          listen: false);
                                  authProvider.email = '';
                                  authProvider.password = '';
                                  authProvider.phone = '';
                                  authProvider.clearToken();
                                  print("Token: ${authProvider.token}");
                                  print('Success  ${authProvider.isSuccess}');
                                  (context).goNamed('login');
                                },
                                child: Text("Login",
                                    style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.0395,
                                        color: Colors.green)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //  Lớp loading
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.isLoading
                        ? Positioned.fill(
                            child: Stack(
                              children: [
                                //  Layer blur
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 1.0, sigmaY: 1.0),
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                ),
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
              ]),
            ),
          ],
        ),
      ]),
    );
  }
}
