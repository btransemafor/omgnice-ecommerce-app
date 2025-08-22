import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CustomLoadingCard extends StatelessWidget {
  final String message;

  const CustomLoadingCard({
    Key? key,
    this.message = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color.fromARGB(255, 17, 16, 16).withOpacity(0.45), // Làm mờ nền Card
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.orange,
                strokeWidth: 5.0,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w400)

            )
          ],
        ),
      ),
    );
  }
}
