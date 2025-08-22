import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountMenuItemModel {
  final String title;
  final IconData iconPrefix;
  final IconData? iconSuffix;
  final VoidCallback onTap;
  

 AccountMenuItemModel({
    required this.title,
    required this.iconPrefix,
    this.iconSuffix,
    required this.onTap,
  });
}


class AccountMenuItem extends StatelessWidget {
  final AccountMenuItemModel model;

  const AccountMenuItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListTile(
      leadingAndTrailingTextStyle: GoogleFonts.poppins(
        fontSize: size.width * 0.035,
        fontWeight: FontWeight.w400,
      ),
      horizontalTitleGap: 17,
      autofocus: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      enableFeedback: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      leading: Icon(model.iconPrefix, color: Colors.green,),
      title: Text(model.title, style: GoogleFonts.poppins(fontSize: size.width*0.035, fontWeight: FontWeight.w400),),
      trailing: Icon(model.iconSuffix, color: Colors.grey.shade400, size: size.width*0.04,),
      onTap: model.onTap,
    );
  }
}