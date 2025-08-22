import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
import 'package:omgnice_ecommerce_app/core/widgets/commonAvatar.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart'
    as user_provider;
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/account_menu.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/general_info_menu.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/widgets/helper_center_menu.dart';
import 'package:provider/provider.dart';

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({Key? key}) : super(key: key);

  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Khởi tạo ScrollController với physics mượt mà
    _scrollController = ScrollController();

    // Animation controller cho fade effects
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    Future.microtask(() async {
      await Provider.of<user_provider.UserProvider>(context, listen: false)
          .getProfileUser();
      final currentUser =
          Provider.of<user_provider.UserProvider>(context, listen: false).user;
      final userId = currentUser?.id;
      if (userId != null) {
        Provider.of<user_provider.UserProvider>(context, listen: false)
            .getStatisticUser(userId);
      }

      // Bắt đầu fade in animation
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<user_provider.UserProvider>().user;
    final statistic = context.watch<user_provider.UserProvider>().stats;
    print(statistic?.totalQuantityOrder);
    print("_---------- Kiem tra vai tro ${user?.roleId}");

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          // Sử dụng NestedScrollView để vuốt mượt mà hơn
          NestedScrollView(
            controller: _scrollController,
            // Cải thiện physics cho vuốt mượt
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: false,
                  snap: false,
                  backgroundColor: Colors.green,
                  centerTitle: true,
                  elevation: 0,
                  // Thêm stretch để có hiệu ứng kéo xuống mượt
                  stretch: true,
                  onStretchTrigger: () async {
                    // Có thể thêm pull-to-refresh ở đây
                    return;
                  },
                  flexibleSpace: FlexibleSpaceBar(
                    // Hiệu ứng parallax mượt mà
                    collapseMode: CollapseMode.parallax,
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    background: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, top: 25),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green,
                              Colors.green.shade600,
                            ],
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Avatar với animation
                            Consumer<user_provider.UserProvider>(
                              builder: (context, userProvider, child) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 241, 242, 238),
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CommonAvatar(
                                      radius: 30,
                                      imageUrl: userProvider.user?.avatar ??
                                          "https://res.cloudinary.com/dehehzz2t/image/upload/v1745651286/download_e4ryfq.png",
                                    ),
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
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      '${user?.name ?? "No Name"} | MEMBER',
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.white, size: 16),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          'Loyalty Point: ${user?.point ?? 0}',
                                          style: GoogleFonts.poppins(
                                            fontSize: size.height * 0.016,
                                            color: Colors.white,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.countertops_rounded,
                                          color: Colors.white, size: 16),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          'Your Coupons: ${statistic?.totalCoupon ?? 0}',
                                          style: GoogleFonts.poppins(
                                            fontSize: size.height * 0.016,
                                            color: Colors.white,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 37, 33, 33).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                child: CustomScrollView(
                  // Physics mượt mà cho phần nội dung
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 5),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                AccountMenu(),
                                const SizedBox(height: 10),
                                GeneralInfoMenu(),
                                const SizedBox(height: 10),
                                HelperCenterMenu(),
                                const SizedBox(height: 20),

                                // Admin button với animation
                                if (user?.roleId == 2)
                                  SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.1),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: _fadeController,
                                      curve: Curves.easeOutCubic,
                                    )),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                      ),
                                      child: Material(
                                        elevation: 4,
                                        borderRadius: BorderRadius.circular(30),
                                        shadowColor: Colors.green.shade300
                                            .withOpacity(0.4),
                                        child: InkWell(
                                          onTap: () {
                                            context.goNamed('adminHomeScreen');
                                          },
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          splashColor:
                                              Colors.green.withOpacity(0.2),
                                          highlightColor:
                                              Colors.green.withOpacity(0.1),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                color: Colors.green.shade600,
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Switch to Admin Mode',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green.shade600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 10),

                                // Sign out button với animation
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: _fadeController,
                                    curve: Curves.easeOutCubic,
                                  )),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 50,
                                    child: Button(
                                      oke: false,
                                      textButton: 'Sign Out',
                                      handleButton: () async {
                                        try {
                                          await Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .logout();

                                          Provider.of<ScreenManager>(context,
                                                  listen: false)
                                              .goToHome();

                                          context.goNamed('login');
                                        } catch (e) {
                                          print("Logout error: $e");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Đăng xuất thất bại. Vui lòng thử lại.',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading overlay với blur effect mượt mà
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: authProvider.isLoading
                    ? Positioned.fill(
                        child: Stack(
                          children: [
                            BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                              child: Container(
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
