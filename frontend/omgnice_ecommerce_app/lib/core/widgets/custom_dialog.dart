import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  //String title = "Thông báo",
  required String content,
  String cancelText = "Cancel",
  String confirmText = "Ok",
  Future<void> Function()? onConfirm,
  bool dismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        //title: Text(title, style: GoogleFonts.poppins()),
        content: Text(content, style: GoogleFonts.poppins(),),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // đóng trước
              if (onConfirm != null) await onConfirm(); // đợi hàm async luôn
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}

class CustomDialog extends StatelessWidget {
  final String content;
  final IconData icon;
  final Color iconColor;

  const CustomDialog({
    super.key,
    required this.content,
    this.icon = Icons.info_outline,
    this.iconColor = Colors.blueGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 260,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: iconColor),
            const SizedBox(height: 12),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
