import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
class MiniMusicBarsLoading extends StatefulWidget {
  @override
  _MiniMusicBarsLoadingState createState() => _MiniMusicBarsLoadingState();
}

class _MiniMusicBarsLoadingState extends State<MiniMusicBarsLoading> with SingleTickerProviderStateMixin {
  late Timer _timer;
  final List<double> _barHeights = [8, 18, 14, 23, 16];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 300), (Timer timer) {
      setState(() {
        for (int i = 0; i < _barHeights.length; i++) {
          _barHeights[i] = _random.nextInt(20).toDouble() + 10;
        }
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
    return Container(
      width: 50,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_barHeights.length, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 2.0),
            width: 6,
            height: _barHeights[index],
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }
}
