import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/provider/favorite_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/widgets/custom_app.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/widgets/banner_slider.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/widgets/product_list_section.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/widgets/recommended_product_section.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/category_menu.dart';
import 'package:omgnice_ecommerce_app/core/widgets/shimmer_widget.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/user_provider.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/home_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/category_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

class CustomHomePage extends StatefulWidget {
  const CustomHomePage({super.key});

  @override
  State<CustomHomePage> createState() => _CustomHomePageState();
}

class _CustomHomePageState extends State<CustomHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
       final provider = Provider.of<FavoriteProvider>(context, listen: false);
   

      // Load user từ bộ nhớ đệm
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final notificationPro = Provider.of<NotificationProvider>(context, listen: false);
      final screenProvider = Provider.of<ScreenManager>(context, listen: false);
      screenProvider.goToHome(); 
      await Future.wait([
        userProvider.loadUser(),
        homeProvider.loadBanners(),
        addressProvider.fetchListAddress(),
        categoryProvider.fetchCategories(),
        context.read<ProductProvider>().getRecommendedProducts(),
        notificationPro.fetchNotifications(),
        provider.fetchFavoriteProducts(),
      ]);
      // Các API phụ thuộc
      await cartProvider.getCart();
      if (categoryProvider.categories.isNotEmpty) {
        await productProvider
            .getProductsByCategory(categoryProvider.categories[0].id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeAppBarHeight = kToolbarHeight + 120;

    return Scaffold(
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: () async {
          await Future.wait([
            Provider.of<HomeProvider>(context, listen: false).loadBanners(),
          ]);
        },
        child: Stack(children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Collapsible App Bar
              SliverAppBar(
                expandedHeight: homeAppBarHeight,
                floating: false,
                pinned: false, // AppBar sẽ biến mất hoàn toàn khi scroll xuống
                snap: false, // AppBar sẽ không snap khi scroll lên một chút
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: HomeAppBar(
                    isPinned: false,
                    cartItemCount: 0,
                  ),
                ),
              ),

              // SliverToBoxAdapter cho phần nội dung cố định
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 10),
                      child: Text(
                        'Sip it. Love it. OMGNICE',
                        style: styleTextTitle,
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.only(top: 20),
                      child: Consumer<HomeProvider>(
                        builder: (context, homeProvider, child) {
                          if (homeProvider.isLoading) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: ShimmerWidget.rectangular(height: 125),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              if (homeProvider.banners.isNotEmpty)
                                BannerSlider(banners: homeProvider.banners),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // SliverToBoxAdapter cho RecommendedProductSection
              SliverToBoxAdapter(
                child: RecommendedProductSection(),
              ),

              // SliverToBoxAdapter cho Categories và Products
              SliverToBoxAdapter(
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    if (categoryProvider.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        CategoryMenu(),
                        if (categoryProvider.categories.isNotEmpty)
                          ProductListSection(),
                      ],
                    );
                  },
                ),
              ),

              // SliverToBoxAdapter để thêm khoảng trống ở cuối
              SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
          // Nút hiển thị chatbox ai
          Positioned(
            bottom: 70,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              elevation: 4,
              onPressed: () {
                context.pushNamed('chatScreen');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30), // Bo tròn ảnh
                child: Image.asset(
                  'assets/icon-chat.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
