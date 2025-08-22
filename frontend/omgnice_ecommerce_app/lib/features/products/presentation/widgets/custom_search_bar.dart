import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return
      Container(
      padding: EdgeInsets.all(14),
      child: GestureDetector(
        onTap: () => {
          // TODO: Switch to Search Screen
          //Navigator.pushNamed(context, '/search-screen'),
          Navigator.push(context, MaterialPageRoute(builder: (context) => Container(color: Colors.deepOrange,)))

        },
        child: TextField(
          enabled: false,
          decoration: InputDecoration(

            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search,color:  Colors.grey.shade500,),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: 'Find Your Beverage ... ',
            hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
          ),
        ),
      )
    );
  }
}
