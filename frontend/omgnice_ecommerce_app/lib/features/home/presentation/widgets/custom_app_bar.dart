import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  CustomAppBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      leading: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Colors.grey.withOpacity(0.5),
          ),
          child: Icon(Icons.person, color: Colors.green)),
      title: Text(
        "OMGNICE",
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {
            // xử lý khi bấm
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120);
}
