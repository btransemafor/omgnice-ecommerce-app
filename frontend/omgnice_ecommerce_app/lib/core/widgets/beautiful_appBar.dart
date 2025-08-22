import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:provider/provider.dart';

class BeautifulAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? backButtonColor;
  final bool gradient;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final bool cartAppbar;

  const BeautifulAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.backButtonColor,
    this.gradient = false,
    this.onBackPressed,
    this.leading,
    this.cartAppbar = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Màu trắng chủ đạo
    final Color whiteBackground = Colors.white;
    final Color accentColor = Colors.grey.shade800;

    return Container(
      decoration: gradient
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green,
                  Colors.green.shade500,
                  Colors.green.shade700,
                  Colors.green.shade200,
                  Colors.green.shade900,
                  Colors.green.shade200,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : BoxDecoration(
              color: backgroundColor ?? whiteBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: gradient
                ? Colors.grey.shade50.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            border: gradient
                ? Border.all(color: Colors.grey.shade200, width: 0)
                : null,
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: titleColor ?? (gradient ? Colors.white : accentColor),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        leading: leading ??
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  // border: Border.all(color: Colors.grey.shade200,),
                ),
                child: IconButton(
                  onPressed: onBackPressed ??
                      () {
                        if (cartAppbar) {
                          if (ModalRoute.of(context)?.settings.name ==
                              '/ProductDetailScreen') {
                            GoRouter.of(context).pop();
                          } else {
                            Provider.of<ScreenManager>(context, listen: false)
                                .onItemSelected(0, context);
                          }
                        } else {
                          final router = GoRouter.of(context);
                          if (router.canPop()) {
                            router.pop();
                          } else {
                            Provider.of<ScreenManager>(context, listen: false)
                                .onItemSelected(0, context);
                          }
                        }
                      },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: backButtonColor ??
                        (gradient ? Colors.white : accentColor),
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
        actions: actions != null
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(children: actions!),
                )
              ]
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
