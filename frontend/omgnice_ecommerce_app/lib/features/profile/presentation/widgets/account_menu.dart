import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/account_menu_item.dart';

class AccountMenu extends StatelessWidget {
  // List <AccountMenuItemModel> items;
  const AccountMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
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
          Text(
            'Account',
            style: GoogleFonts.poppins(
                fontSize: size.height * 0.022, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          AccountMenuItem(
            model: AccountMenuItemModel(
              title: 'Profile',
              iconPrefix: Icons.person_2_outlined,
              iconSuffix: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
                (context).pushNamed('profile');
              },
            ),
          ),
          AccountMenuItem(
              model: AccountMenuItemModel(
            title: 'My Order',
            iconPrefix: Icons.shopping_bag_outlined,
            iconSuffix: Icons.arrow_forward_ios,
            onTap: () {
              // Handle tap
              context.pushNamed('orderScreen'); 
            },
          )),

          AccountMenuItem(
            model: AccountMenuItemModel(
              title: 'Setting',
              iconPrefix: Icons.settings_outlined,
              iconSuffix: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
                context.pushNamed('settings');
              },
            ),
          ),
        ],
      ),
    );
  }
}
