import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantityButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuantityButton({
    Key? key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildAddToCartContainer(onRemove, onAdd),
        buildQuantityContainer(quantity),
      ],
    );
  }
}

// 1. Nút tăng giảm số lượng
Widget buildQuantityButton(IconData icon, VoidCallback? onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: Colors.black,
        size: 25,
      ),
    ),
  );
}


// 3. Phần hiển thị số lượng ở giữa
Widget buildQuantityContainer(int quantity) {
  return Positioned(
    left: 59,
    right: 59,
    top: 0,
    bottom: 0,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "$quantity",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}

// 4. Container chứa các nút (+) và (-)
Widget buildAddToCartContainer(VoidCallback onRemove, VoidCallback onAdd) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBBC05),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildQuantityButton(Icons.remove, onRemove),
          const SizedBox(width: 50),
          buildQuantityButton(Icons.add, onAdd),
        ],
      ),
    ),
  );
}
