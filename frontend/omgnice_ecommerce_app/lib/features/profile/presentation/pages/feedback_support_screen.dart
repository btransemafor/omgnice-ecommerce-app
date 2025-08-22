import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
class FeedbackSupportScreen extends StatefulWidget {
  @override
  _FeedbackSupportScreenState createState() => _FeedbackSupportScreenState();
}

class _FeedbackSupportScreenState extends State<FeedbackSupportScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // Ẩn bàn phím khi nhấn ra ngoài
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Nút Back
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tiêu đề
                Text(
                  "Feedback & Support",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "Let us know your feeling",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.04,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Các TextField
                _buildTextField("Your Name", size),
                const SizedBox(height: 10),
                _buildTextField("Phone Number", size),
                const SizedBox(height: 10),
                _buildTextField("Email", size),

                const SizedBox(height: 10),
                // Message Box
                _buildTextField(
                    "Message (Maximum 1500 characters)", size, maxLines: 8),
                const SizedBox(height: 20),
                // Nút Submit
                Button(textButton: 'Submit', oke:true,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, Size size, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        /*
        contentPadding: maxLines > 1
            ? const EdgeInsets.symmetric(horizontal: 15, vertical: 15)
            : const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            */

        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.black45,
          fontSize: size.height * 0.018,
        ),
        filled: true,
        fillColor: const Color(0xFFE0E0E0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}