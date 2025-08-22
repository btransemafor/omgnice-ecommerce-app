import 'package:flutter/material.dart';

class Dialogs {
  static void showVoucherStatusDialog(BuildContext context, bool success, String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0),
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(); // auto close after 2s
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4), 
              borderRadius: BorderRadius.circular(20)
            ),
            padding: const EdgeInsets.all(24),
            width: 240,
            height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  size: 40,
                  color: success ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 12),
                Text(
                  success
                      ? 'Voucher applied: $code'
                      : 'You do not meet the voucher conditions.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
