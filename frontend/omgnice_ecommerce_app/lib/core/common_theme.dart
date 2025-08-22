import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTheme {
  static ThemeData lightTheme = ThemeData(
    // brightness: Brightness.light,
    primaryColor: const Color(0xFF699D3C),
    scaffoldBackgroundColor: const Color(0xffffffff),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white, // AppBar trắng
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black, // ← chữ đen
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black), // ← icon đen
    ),

    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFfd9002),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0f1317), // Màu nền tối
    scaffoldBackgroundColor: const Color(0xFF0f1317),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0f1317),
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFfd9002),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
