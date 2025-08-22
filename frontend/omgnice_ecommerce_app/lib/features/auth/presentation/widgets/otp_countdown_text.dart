import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/otp_countdown_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpCountdownText extends StatelessWidget {
  const OtpCountdownText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<OtpCountdownProvider>(context);

    if (provider.canResend) return const SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "00:${provider.secondsRemaining.toString().padLeft(2, '0')}",
        style: GoogleFonts.poppins(
          fontSize: size.width * 0.0495,
          color: Colors.red,
        ),
      ),
    );
  }
}
