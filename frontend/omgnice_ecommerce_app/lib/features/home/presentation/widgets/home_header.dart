import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size ;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.width * 0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Item Avatar Default
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.green,
            child: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape:BoxShape.circle
              ),
              child: Icon(Icons.person, color: Colors.green),
            ),
          ),
          // Item: Name
          Text("OMGNICE" , style: GoogleFonts.poppins(fontSize: size.width * 0.065, fontWeight: FontWeight.w700),),

          // Icon Notification

          Icon(Icons.notifications_outlined, color: Colors.green, size: size.width * 0.08,)
        ],
      ),
    );
  }
}
