import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SearchSreen extends StatefulWidget {
  const SearchSreen({Key?key}):super(key:key);

  @override
  State<SearchSreen> createState() => _SearchSreenState();
}

class _SearchSreenState extends State<SearchSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Search Bar Tutorial'),
      ),
      body: Column(
        children: [
          SearchBar(),
          Expanded(
            child: Center(
              child: Text('Search results will be displayed here!'),
            ),
          ),
        ],
      ),
    );
  }
}
