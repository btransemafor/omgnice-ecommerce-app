import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/account_menu_item.dart';

class GeneralInfoMenu extends StatelessWidget {
  const GeneralInfoMenu({
    Key? key,
  }): super(key: key);
   @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('General Infomation', style: GoogleFonts.poppins(fontSize: size.height*0.022, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          AccountMenuItem(
            model: AccountMenuItemModel(
              title: 'Terms of Service',
              iconPrefix: Icons.article_outlined,
              iconSuffix: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
              },
            ),
          ),
          AccountMenuItem(
            model: AccountMenuItemModel(
              title: 'Policy',
              iconPrefix: Icons.policy_outlined,
              iconSuffix: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
                context.pushNamed('policyScreen');
              },
            )
          ),
          AccountMenuItem(
           model: AccountMenuItemModel(
              title: 'About OMGNICE',
              iconPrefix: Icons.info_outline,
              iconSuffix: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
                context.pushNamed('aboutScreen'); 
              },
            ),
          ),
        ],
      ),
    );
  }
}