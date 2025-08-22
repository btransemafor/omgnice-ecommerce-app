import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CardAddress extends StatelessWidget {
  final String text;
  final bool is_province;
  final bool is_district;
  final bool is_ward;
  final bool isActive; 

  const CardAddress({
    super.key,
    required this.text,
    required this.is_province,
    required this.is_district,
    required this.is_ward,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined,
              color: isActive
                  ? Colors.green
                  : const Color.fromARGB(255, 4, 90, 31)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
