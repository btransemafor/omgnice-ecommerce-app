import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/app_router.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/account_menu_item.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/user_provider.dart'
    as userAuth;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void handleDelete(BuildContext context) {
  bool isPasswordVisible = false; // Di chuyển biến vào trong hàm
  TextEditingController passwordController = TextEditingController(); // Khởi tạo cục bộ

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text(
                  "Delete Account",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Are you sure? This action cannot be undone.",
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: isPasswordVisible
                            ? const Color.fromARGB(255, 50, 52, 54)
                            : Colors.grey[600],
                      ),
                      onPressed: () {
                        setDialogState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      tooltip: isPasswordVisible ? 'Hide password' : 'Show password',
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (passwordController.text.isNotEmpty) {
                    Navigator.of(context).pop();
                    _performAccountDeletion(context, passwordController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter your password"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  "Delete Account",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

  void _performAccountDeletion(BuildContext context, String password) async {
    print('Starting account deletion for password: $password');

    // Lưu lại các provider references trước khi bắt đầu async operations
    final userPro = Provider.of<userAuth.UserProvider>(context, listen: false);
    final authPro = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Lưu lại navigator để sử dụng sau
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.red),
                SizedBox(height: 16),
                Text(
                  "Deleting account...",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      print('Loading user info');
      await userPro.loadUser();
      final userId = userPro.userInfo?.id;

      if (userId == null) {
        throw Exception("User ID not found");
      }

      // Check password của user trước khi xóa
      final isPasswordValid = await authPro.checkPassword(password);
      print('isPasswordValid = $isPasswordValid');

      if (!isPasswordValid) {
        throw Exception('Password is not match. Please try again!!!');
      }

      print('Deleting user with id: $userId');

      // Delete user account
      final isSuccess = await userProvider.deleteUser();
      print('Deletion result: $isSuccess');

      // Close loading dialog - sử dụng navigator đã lưu
      navigator.pop();

      if (isSuccess) {
        // Perform logout
        print('Calling authPro.logout()');
        await authPro.logout();

        // Navigate using rootNavigatorKey
        final navigatorContext = rootNavigatorKey.currentContext;
        if (navigatorContext != null) {
          // Sử dụng SchedulerBinding để đảm bảo navigation được thực hiện sau khi frame hiện tại hoàn thành
          SchedulerBinding.instance.addPostFrameCallback((_) {
            print('Navigating to account-deleted page');
            GoRouter.of(navigatorContext).go('/account-deleted');

            // Show success message sau một chút delay
            Future.delayed(Duration(milliseconds: 500), () {
              final currentContext = rootNavigatorKey.currentContext;
              if (currentContext != null) {
                ScaffoldMessenger.of(currentContext).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Account deleted successfully"),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            });
          });
        } else {
          print('Navigator context not available, showing error');
          _showErrorWithScaffoldMessenger(
              scaffoldMessenger, "Navigation failed after deletion");
        }
      } else {
        _showErrorWithScaffoldMessenger(
            scaffoldMessenger, "Failed to delete account. Please try again.");
      }
    } catch (e) {
      print('Error during deletion: $e');
      // Close loading dialog nếu vẫn mở
      try {
        navigator.pop();
      } catch (popError) {
        print('Error closing dialog: $popError');
      }

      _showErrorWithScaffoldMessenger(scaffoldMessenger, e.toString());
    }
  }

  void _showErrorWithScaffoldMessenger(
      ScaffoldMessengerState scaffoldMessenger, String error) {
    print('Showing error with ScaffoldMessenger: $error');
    try {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text("Error: $error")),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    } catch (e) {
      print('Error showing SnackBar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final styleCommon = GoogleFonts.poppins(
        fontSize: size.height * 0.019, fontWeight: FontWeight.w700);

    return Scaffold(
      appBar: BeautifulAppBar(
        title: 'Settings',
        gradient: true,
      ),
      backgroundColor: const Color(0xFFF1F8E9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Setup', style: styleCommon),
                  AccountMenuItem(
                    model: AccountMenuItemModel(
                      title: 'Delete Account',
                      iconPrefix: Icons.person_off_outlined,
                      onTap: () => handleDelete(context),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Security', style: styleCommon),
                  AccountMenuItem(
                    model: AccountMenuItemModel(
                      title: 'Change Password',
                      iconPrefix: Icons.lock_outline,
                      iconSuffix: Icons.arrow_forward_ios,
                      onTap: () {
                        context.pushNamed('changePassword');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountDeletedScreen extends StatelessWidget {
  const AccountDeletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building AccountDeletedScreen');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
              SizedBox(height: 24),
              Text(
                "Account Deleted",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                "Thank you for using our services.\nWe're sorry to see you go.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 18, 85, 15),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    print('Navigating to /login from AccountDeletedScreen');
                    context.go('/login');
                  },
                  child: Text(
                    "Create New Account",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  print('Navigating to /welcome from AccountDeletedScreen');
                  context.go('/login');
                },
                child: Text(
                  "Back to Home",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
