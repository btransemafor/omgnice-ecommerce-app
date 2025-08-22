// SizeSelector.dart
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

class SizeSelector extends StatelessWidget {
  final double priceS;
  final double priceM;
  final double priceL;

  const SizeSelector({
    Key? key,
    required this.priceS,
    required this.priceL,
    required this.priceM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, provider, _) {
      final selectedSize = provider.selectedSize;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildCupSize(context, "Small", priceS, selectedSize == 'S'),
          buildCupSize(context, "Medium", priceM, selectedSize == 'M'),
          buildCupSize(context, "Large", priceL, selectedSize == 'L'),
        ],
      );
    });
  }
}



const mapping_variant  = {
  'Small' : 'S' , 
  'Medium' : 'M', 
  'Large': 'L'
};


Widget buildCupSize(
    BuildContext context, String name, double price, bool isSelected) {
  final sizeMapping = {
    'Small': '250 ml',
    'Medium': '550 ml',
    'Large': '700 ml'
  };

  return GestureDetector(
    onTap: () {
      print("Đã chọn size $name");
      Provider.of<ProductProvider>(context, listen: false).chooseSize(mapping_variant[name]!);
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF74BF32) : const Color(0xFFF6F8F7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(31, 236, 51, 51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isSelected ? Colors.green.shade700 : Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_cafe_rounded,
            size: 34,
            color: isSelected ? Colors.white : Colors.green.shade600,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sizeMapping[name] ?? '',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isSelected ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  );
}
