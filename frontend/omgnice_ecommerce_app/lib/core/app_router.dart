import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart';
import 'package:omgnice_ecommerce_app/features/Chat/chat_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/customers/presentation/screens/user_detail_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/customers/presentation/screens/user_order_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/setting/presentation/screens/create_voucher_screen.dart';
import 'package:omgnice_ecommerce_app/features/auth/auth_export.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/pages/random_password_screen.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/pages/verify_screen.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:omgnice_ecommerce_app/features/checkout/representation/screens/checkout_screen.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/screens/test_fav.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/pages/product_by_category_screen.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/screens/add_address_screen.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/screens/my_address_screen.dart';
import 'package:omgnice_ecommerce_app/features/onboarding_Slash/representation/screens/onboarding_screen.dart';
//import 'package:omgnice_ecommerce_app/features/onboarding_Slash/representation/onboarding_screen.dart';
import 'package:omgnice_ecommerce_app/features/onboarding_Slash/representation/screens/slash_screen.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
import 'package:omgnice_ecommerce_app/features/payment/presentation/screens/payos_webview_page.dart';
import 'package:omgnice_ecommerce_app/features/payment/test-pay.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/pages/product_detail_loading.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/about_screen.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/change_password_screen.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/contact_screen.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/faq_screen.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/policy_screen.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/setting_screen.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/pages/my_promotion_screen.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/pages/home_screen.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/pages/promotion_screen.dart';
import 'package:omgnice_ecommerce_app/features/orders/order_exports.dart';
import 'package:omgnice_ecommerce_app/features/admin/admin_route.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'slashScreen',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/onBoarding',
        name: 'onboarding',
        builder: (context, state) => OnboardingScreen(),
        //const
      ),
//SplashScreen()

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const SignInScreen(),
        //const
      ),

      GoRoute(
        path: '/verify',
        name: 'verify',
        builder: (context, state) {
          final flow = state.extra as VerificationFlow;
          return VerifyScreen(flow: flow);
        },
      ),

      GoRoute(
          path: 'order-user-screen',
          name: 'orderUser',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final List<OrderEntity> orders =
                extra['orders'] as List<OrderEntity>;
            return UserOrdersScreen(allOrders: orders);
          }),

 // Trong GoRouter routes:
GoRoute(
  name: 'randomPassword',
  path: '/random-password',
  builder: (context, state) {
    final pwRandom = state.extra as String? ?? '';
    return RandomPasswordScreen(randomPassword: pwRandom);
  },
), 

      GoRoute(
        path: '/user-Detail-Screen',
        name: 'userDetail',
        builder: (context, state) {
          final extra = state.extra;

          if (extra is Map<String, dynamic> && extra.containsKey('userId')) {
            final String userId = extra['userId'];
            return UserDetailScreen(userId: userId);
          } else {
            // Trường hợp không truyền đúng extra → show lỗi
            return const Scaffold(
              body: Center(child: Text('Thiếu hoặc sai dữ liệu userId')),
            );
          }
        },
      ),

      GoRoute(
        path: '/congratulations',
        name: 'congrats',
        builder: (context, state) => const SignupSuccessScreen(),
      ),

      GoRoute(path: '/account-deleted', 
      name: 'accountDeleted', 
      builder: (context, state) => const AccountDeletedScreen()
      ), 
      GoRoute(
        path: '/set-new-password',
        name: 'setNewPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/sign-up-screen',
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      /* GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ), */
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/momo',
        name: 'momo',
        builder: (context, state) => MoMoPaymentScreen(),
      ),
      GoRoute(
        path: '/home-screen',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/cart-screen',
        name: 'cart',
        builder: (context, state) => CartScreen(),
      ),
      GoRoute(
        path: '/checkout-screen',
        name: 'checkout',
        builder: (context, state) => CheckoutScreen(),
      ),
      GoRoute(
        path: '/add-address-screen',
        name: 'addAddress',
        builder: (context, state) => AddAddressScreen(),
      ),
      GoRoute(
        path: '/my-address-screen',
        name: 'myAddress',
        builder: (context, state) => MyAddressScreen(),
      ),
      GoRoute(
        path: '/choose-shipping-screen',
        name: 'chooseShipping',
        builder: (context, state) => ChooseShippingScreen(),
      ),
      GoRoute(
        path: '/choose-payment-screen',
        name: 'choosePayment',
        builder: (context, state) => ChoosePaymentScreen(),
      ),
      GoRoute(
        path: '/setting-screen',
        name: 'settings',
        builder: (context, state) => SettingScreen(),
      ),
      GoRoute(
        path: '/profile-screen',
        name: 'profile',
        builder: (context, state) => UserProfileScreen(),
      ),
      GoRoute(
        path: '/my-promotion-screen',
        name: 'mypromotion',
        builder: (context, state) => MyPromotionScreen(),
      ),
      GoRoute(
        path: '/promotion-screen',
        name: 'promotion',
        builder: (context, state) => PromotionScreen(),
      ),
      GoRoute(
          path: '/change-password-screen',
          name: 'changePassword',
          builder: (context, state) => ChangePasswordScreen()),
      GoRoute(
          path: '/order-success',
          name: 'orderSuccess',
          builder: (context, state) => OrderSuccessScreen()),
      GoRoute(
          path: '/user-order-detail',
          name: 'userOrderDetail',
          builder: (context, state) {
            final order = state.extra as OrderEntity;
            return OrderDetailScreen(order: order);
          }),
      GoRoute(
          path: '/test-Fav',
          name: 'testFav',
          builder: (context, state) => TestFav()),
      GoRoute(
          path: '/track-order-screen',
          name: 'trackOrder',
          builder: (context, state) => TrackOrderScreen()),
      GoRoute(
          path: '/contact-screen',
          name: 'contactScreen',
          builder: (context, state) => ContactScreen()),

      GoRoute(
          // ChatScreen
          path: '/chat-screen',
          name: 'chatScreen',
          builder: (context, state) => ChatScreen()),

      GoRoute(
          // ChatScreen
          path: '/about-screen',
          name: 'aboutScreen',
          builder: (context, state) => AboutScreen()),

      GoRoute(
          // ChatScreen
          path: '/policy-screen',
          name: 'policyScreen',
          builder: (context, state) => PolicyScreen()),
      // FAQScreen
      GoRoute(
          // ChatScreen
          path: '/faqs-screen',
          name: 'faqsScreen',
          builder: (context, state) => FaqsScreen()),
      GoRoute(
          path: '/create-promotion-screen',
          name: 'createPromotion',
          builder: (context, state) => CreatePromotionScreen()),
      GoRoute(
          path: '/product-detail-screen',
          name: 'productDetailScreen',
          builder: (context, state) {
            final int productID = state.extra as int;
            return ProductDetailLoadingScreen(
              productId: productID,
            );
          }),

      GoRoute(
          path: '/product-by-category',
          name: 'productCategory',
          builder: (context, state) {
            final int categoryID = state.extra as int;
            return ProductListScreen(
              categoryId: categoryID,
            );
          }),
/*       GoRoute(
        name: 'payosWebview',
        path: '/payos-webview',
        builder: (context, state) {
          final extra = state.extra as Map;
          return PayOSWebViewPage(
            checkoutUrl: extra['checkoutUrl'],
            returnUrl: extra['returnUrl'],
            orderID: extra['OrderID'] ?? ''
          );
        },
      ),
 */
      GoRoute(
        name: 'payosWebview',
        path: '/payos-webview',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            throw Exception('Navigation extra data is null');
          }

          final checkoutUrl = extra['checkoutUrl'] as String?;
          final orderId = extra['orderId'] as String?;
          final orderCode = extra['orderCode'] as String?;

          if (checkoutUrl == null || orderId == null || orderCode == null) {
            // Log the error and redirect to an error page or home
            debugPrint(
                'Error: Missing checkoutUrl or orderId in navigation extra');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.goNamed('home'); // Redirect to home as a fallback
            });
            return const SizedBox(); // Return a placeholder widget
          }

          return PayOSWebViewPage(
            checkoutUrl: checkoutUrl,
            orderId: orderId,
            orderCode: orderCode,
          );
        },
      ),
      /*  GoRoute(
          path: '/payos-webview-screen',
          name: 'payOsWebview',
          builder: (context, state) => PayOSWebViewPage()),  */

      GoRoute(
          path: '/order-screen',
          name: 'orderScreen',
          builder: (context, state) => OrderScreen()),
      ...adminRoutes
    ],
  );
}
