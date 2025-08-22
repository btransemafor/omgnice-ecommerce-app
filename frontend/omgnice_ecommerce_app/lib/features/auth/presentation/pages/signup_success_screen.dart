import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({Key? key}) : super(key: key);

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen>
    with TickerProviderStateMixin {
  bool showTick = false;
  bool showFirework = true;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeIn,
    );

    // Sau 3s: ẩn pháo hoa, hiện tick + animation
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showFirework = false;
        showTick = true;
      });
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; 
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showFirework)
                Lottie.asset(
                  'assets/lottie/success_register.json',
                  width: 300,
                  repeat: true,
                ),
        
              if (showTick) ...[
                Lottie.asset(
                  'assets/lottie/tick_success.json',
                  width: 350,
                  repeat: false,
                ),
                //const SizedBox(height: 6),
                Text(
                  'Thank You',
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 100),
                Text(
                  'Your Account has been created',
                  style: GoogleFonts.poppins(
                    fontSize: size.height * 0.02 ,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: Tween(begin: 0.9, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _buttonController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Button(
                        oke:true,
                        textButton: 'Continue',
                        handleButton: () {
                          context.goNamed('login');
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
