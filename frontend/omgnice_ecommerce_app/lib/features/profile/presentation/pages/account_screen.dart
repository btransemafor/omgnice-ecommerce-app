import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_appbar_common.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/account_menu.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/account_menu_item.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/general_info_menu.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/helper_center_menu.dart';
class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppbarCommon(title: 'Account'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AccountMenu(), 
            GeneralInfoMenu(), 
            HelperCenterMenu(), 
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50,
              child: Button(oke: false, textButton: 'Sign Out', 
                // Handle sign out action
              ),
            ),
            const SizedBox(height: 150),
          ],
        ),
      )
    );
  }
}