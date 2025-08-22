import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/product.dart';

class SaveDiscountCard extends StatelessWidget {
  final ProductCardModel product; 
  const SaveDiscountCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: InvertedHouseClipper(),
        child: Container(
          padding: EdgeInsets.only(top: 5),
          width: 45,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color.fromARGB(255, 164, 252, 183),
                Color.fromARGB(255, 156, 239, 158),
                Color.fromARGB(255, 231, 241, 236),
                Color.fromARGB(255, 255, 255, 255),
              ],
              tileMode: TileMode.mirror,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 6),
                blurRadius: 10,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: -2,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          child: 
          Column(
            children: [
              Center(child: Text('${product.discountPercent} %', style: GoogleFonts.poppins(fontSize: 12, color: const Color.fromARGB(255, 16, 148, 20), fontWeight: FontWeight.w800),)),

              Center(child: Text('Save', style: GoogleFonts.poppins(fontSize: 12, color: const Color.fromARGB(255, 16, 148, 20), fontWeight: FontWeight.w800),)),
            ],
          ),
        ),
      ),
    );
  }
}

class InvertedHouseClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.moveTo(0, 0); // Top-left
    path.lineTo(size.width, 0); // Top-right
    path.lineTo(size.width, size.height * 0.75); // Bottom-right of square
    path.lineTo(size.width / 2, size.height); // Bottom middle (triangle tip)
    path.lineTo(0, size.height * 0.75); // Bottom-left of square
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
