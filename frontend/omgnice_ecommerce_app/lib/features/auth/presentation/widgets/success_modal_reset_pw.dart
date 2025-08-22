import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';

class SuccessModalResetPw extends StatelessWidget {
  const SuccessModalResetPw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 220, bottom: 220, left: 30, right: 30),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.asset(
                      'assets/success.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
                const SizedBox(height: 20),
                Text(
                  'Reset password successfully',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Your password has been successfully reset. Please log in to access the app.',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  child: Button(
                    textButton: 'Back to Login',
                    oke: false,
                    handleButton: () {
                      Navigator.pop(context);
                      // Chuyen den Login Screen
                      
                      (context).goNamed('login'); 
                    },
                  ),
                )
              ],
            ),
          ),

          // Close
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.close_rounded, size: 28),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
