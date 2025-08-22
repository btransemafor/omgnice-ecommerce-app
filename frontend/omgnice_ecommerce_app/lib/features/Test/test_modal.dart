import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';

class TestModal extends StatelessWidget {
  const TestModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ShowModal Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModal<void>(
              // <=== SỬA LỖI Ở ĐÂY, PHẢI CÓ KIỂU DỮ LIỆU ĐƯỢC TRẢ VỀ!
              context: context,
              configuration: const FadeScaleTransitionConfiguration(
                barrierColor: Colors.black54,
                barrierDismissible: true,
                transitionDuration: Duration(milliseconds: 500),
              ),
              builder: (context) => const ModalContent(),
            );
          },
          child: Text('Open Modal'),
        ),
      ),
    );
  }
}

class ModalContent extends StatelessWidget {
  const ModalContent({Key? key}) : super(key: key);

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
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/sign-in-screen',
                        (route) => false,
                      );
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
