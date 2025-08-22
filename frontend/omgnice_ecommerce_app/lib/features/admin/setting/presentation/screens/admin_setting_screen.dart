import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/commonAvatar.dart';
import 'package:omgnice_ecommerce_app/features/admin/setting/presentation/screens/admin_create_banner.dart';
import 'package:omgnice_ecommerce_app/features/admin/setting/presentation/screens/boardcast_notification_screen.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/user_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart'
    as user_provider;
import 'package:provider/provider.dart';

class AdminSettingScreen extends StatefulWidget {
  const AdminSettingScreen({Key? key}) : super(key: key);

  @override
  State<AdminSettingScreen> createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
  // Define a consistent color palette
  final Color primaryColor = const Color(0xFF1A7B3E); // Deep green
  final Color secondaryColor = const Color(0xFF165832); // Darker green
  final Color accentColor = const Color(0xFF42C284); // Light green
  final Color surfaceColor = Colors.white;
  final Color textPrimaryColor = const Color(0xFF2D3142); // Dark gray
  final Color textSecondaryColor = const Color(0xFF9194A1); // Medium gray
  final Color dividerColor = const Color(0xFFEEEFF2); // Light gray

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<user_provider.UserProvider>(context, listen: false)
          .getProfileUser();
          await Provider.of<UserProvider>(context, listen: false).loadUser(); 
    });
  }

  void _showLogoutDialog() {
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Log Out',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
              ),
              content: isLoading
                  ? SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                          backgroundColor: Colors.green.withOpacity(0.3),
                        ),
                      ),
                    )
                  : Text(
                      'Are you sure you want to log out?',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: textSecondaryColor,
                      ),
                    ),
              actions: isLoading
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(color: textSecondaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .logout();
                         /*  Provider.of<ScreenManager>(context, listen: false)
                              .goToHome(); */
                          context.goNamed('login');
                        //  Navigator.of(context).pop();
                        },
                        child: Text(
                          'Log Out',
                          style: GoogleFonts.poppins(color: primaryColor),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100,
                backgroundColor: primaryColor,
                centerTitle: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.only(left: 20, top: 25),
                    color: primaryColor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                            return Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CommonAvatar(
                                radius: 30,
                                imageUrl: userProvider.userInfo?.avatar ??
                                    "https://res.cloudinary.com/dehehzz2t/image/upload/v1745651286/download_e4ryfq.png",
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer<UserProvider>(
                                builder: (context, userProvider, child) {
                                  return Row(
                                    children: [
                                      Text(
                                        '${userProvider.userInfo?.name ?? "No Name"} | ADMIN',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.verified,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Other Setting",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Settings Items
                      _buildSettingItem(
                        context,
                        icon: Icons.campaign_outlined,
                        title: "Broadcast Promotions",
                        subtitle:
                            "Send drink deals or event notifications to all users",
                        type: 'customer',
                        onTap: () {
                          // Navigator.push to BroadcastPromotionScreen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BroadcastNotificationScreen()));
                        },
                      ),
                      const SizedBox(height: 12),

                      _buildSettingItem(
                        context,
                        icon: Icons.local_offer_outlined,
                        title: "Create Voucher",
                        subtitle: "Offer discounts for beverages or combos",
                        type: 'operations',
                        onTap: () {
                          // Navigator.push to CreateVoucherScreen
                          context.pushNamed('createPromotion');
                        },
                      ),
                      const SizedBox(height: 12),

                      _buildSettingItem(
                        context,
                        icon: Icons.image_outlined,
                        title: "Create Banners",
                        subtitle: "Design banners for beverages or combos",
                        type: 'marketing',
                        onTap: () {
                          // Navigator.push to CreateBannerScreen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BannerManagementScreen()));
                        },
                      ),
                      const SizedBox(height: 12),

                      Divider(height: 8, thickness: 1, color: dividerColor),
                      const SizedBox(height: 24),

                      Text(
                        "Settings",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildSettingItem(
                        context,
                        icon: Icons.swap_horiz,
                        title: "Switch View Mode",
                        subtitle: "Toggle between admin and shopping views",
                        type: 'view_mode',
                        onTap: () {
                          // Navigator.push to ViewModeSwitcherScreen
                          // Reset về tab 0 trướ khi về trang login
                          Provider.of<ScreenManager>(context, listen: false)
                              .goToHome();
                          context.goNamed('home');
                        },
                      ),

                      const SizedBox(height: 12),

                      _buildSettingItem(
                        context,
                        icon: Icons.logout_outlined,
                        title: "Log Out",
                        subtitle: "Sign out of your admin account",
                        type: 'logout',
                        onTap: _showLogoutDialog,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Get icon color based on function type
  Color _getIconColor(String type) {
    switch (type) {
      case 'marketing':
        return primaryColor; // Green for marketing
      case 'operations':
        return const Color(0xFF2196F3); // Blue for operations
      case 'customer':
        return const Color(0xFF9C27B0); // Purple for customer relations
      case 'system':
        return const Color(0xFF607D8B); // Blue Grey for system
      case 'logout':
        return const Color(0xFFF44336); // Red for logout
      default:
        return accentColor;
    }
  }

  // Get background color based on function type
  Color _getBackgroundColor(String type) {
    switch (type) {
      case 'marketing':
        return const Color(0xFFE8F5E9); // Light green for marketing
      case 'operations':
        return const Color(0xFFE3F2FD); // Light blue for operations
      case 'customer':
        return const Color(0xFFF3E5F5); // Light purple for customer relations
      case 'system':
        return const Color(0xFFECEFF1); // Light blue grey for system
      case 'logout':
        return const Color(0xFFFFEBEE); // Light red for logout
      default:
        return Colors.grey.shade50;
    }
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String type,
    required VoidCallback onTap,
  }) {
    final Color iconColor = _getIconColor(type);
    final Color bgColor = _getBackgroundColor(type);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
