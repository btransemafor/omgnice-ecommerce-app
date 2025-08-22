import 'package:flutter/material.dart'; 
class CommonButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;

  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = const Color.fromARGB(255, 174, 251, 177),
    this.textColor = const Color(0xFFFFFFFF),
    this.width = double.infinity,
    this.height = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}