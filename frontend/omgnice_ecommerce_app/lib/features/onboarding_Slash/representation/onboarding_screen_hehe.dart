import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/presentation/pages/sign_up_screen.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF415231),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Container(
                      width: size.width * 0.5,
                      height: size.width * 0.5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'OMGNICE',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.095,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sip your favorite drinks anytime',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.035,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Switch to Sign Up Screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3AF4A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Get Started',
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            );
          },
        ),
      ),
    );
  }
}
