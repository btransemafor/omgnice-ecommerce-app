import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/static_word.dart';
import 'package:omgnice_ecommerce_app/features/search/presentation/screens/search_screen.dart'; // Import file StaticWords

class AnimatedSearchBar extends StatefulWidget {
  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % StaticWords.searchPlaceholders.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen())) ; 
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: size.width*0.015),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 5),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: Text(
                  StaticWords.searchPlaceholders[_currentIndex],
                  key: ValueKey<String>(StaticWords.searchPlaceholders[_currentIndex]),
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
