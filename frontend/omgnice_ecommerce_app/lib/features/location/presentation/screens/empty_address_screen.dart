import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; // Thêm package này nếu muốn dùng animation

class EmptyAddressWidget extends StatelessWidget {
  final VoidCallback onAddNew;
  
  const EmptyAddressWidget({
    Key? key,
    required this.onAddNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bạn có thể thay thế đoạn này bằng Lottie animation nếu muốn
          Image.asset(
            'assets/images/address_empty.png',
            height: size.height * 0.2,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.location_off_outlined,
                size: 100,
                color: Colors.grey.shade400,
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'No Address Found',
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 10),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'You haven\'t added any delivery address yet. Add a new address to get your orders delivered.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.035,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          ElevatedButton.icon(
            onPressed: onAddNew,
            icon: const Icon(Icons.add_location_alt, color: Colors.white),
            label: Text(
              'Add New Address',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}