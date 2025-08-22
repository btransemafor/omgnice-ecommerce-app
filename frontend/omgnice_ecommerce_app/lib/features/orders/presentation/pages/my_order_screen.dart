

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrderScreen6 extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(100), child: AppBar(
          //
          title: Align(
            alignment: Alignment.center,
              child: Text('OMGNICE', style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),)),
          backgroundColor: Colors.white,
          // elevation: 10,

          // Bottom Appbar
          bottom: TabBar(tabs: [
            Tab(text: "processing"),
            Tab(text: "Delivery"),
            Tab(text: "Cancel")
          ]),


        )),

            body: TabBarView(children: [
              Container(color: Colors.white,),
              Container(color: Colors.black,),
              Container(color: Colors.green,)
          ]),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();

}