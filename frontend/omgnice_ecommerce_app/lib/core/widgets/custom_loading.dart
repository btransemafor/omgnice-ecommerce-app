import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/widgets/mini_music_bar_loading.dart';
class CustomLoading extends StatelessWidget {
  const CustomLoading({Key?key}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: MiniMusicBarsLoading()
    );
  }
}