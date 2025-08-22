import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessHelper {
  static void showSuccess(BuildContext context, String? message) {
    Flushbar(
      //  Custom font ở đây
      messageText: Text(
        message ?? '',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
