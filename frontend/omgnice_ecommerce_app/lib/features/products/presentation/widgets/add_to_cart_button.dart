import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddToCartButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(
        'Add to cart',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size.width * 0.04,
        ),
      ),
      icon: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF74BF32), // Màu cam chủ đạo của bạn
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        shadowColor: Colors.black.withOpacity(0.4),
        elevation: 10,
      ),
    );
  }
}
