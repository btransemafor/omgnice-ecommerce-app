import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppbarCommon extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? backButtonColor;

  const CustomAppbarCommon({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.backButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 0.9,
      toolbarHeight: 60,
      backgroundColor: backgroundColor ?? Colors.white,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 17,
          color: titleColor ?? Colors.black87,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: backButtonColor ?? Colors.black87,
            ),
          ),
        ),
      ),
      centerTitle: true,
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(children: actions!),
              )
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
