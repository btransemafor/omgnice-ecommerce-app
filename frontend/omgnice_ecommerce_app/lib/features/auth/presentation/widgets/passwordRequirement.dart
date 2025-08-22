import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordRequirement extends StatelessWidget {
  final bool isValid;
  final String requirementText;

  const PasswordRequirement({
    super.key,
    required this.isValid,
    required this.requirementText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Row(
        key: ValueKey(isValid),
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : const Color.fromARGB(255, 235, 16, 16),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            requirementText,
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 13, 152, 108),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
