import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(

        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[100],
          //border: Border.all(width: 1),
          /*
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],

          */

        ),
        child: Icon(
          Icons.arrow_back,
          color: Color(0xff489727), // Màu cam bạn muốn
          size: 26,
        ),
      ),
    );
  }
}
