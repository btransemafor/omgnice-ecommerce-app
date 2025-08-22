import 'package:go_router/go_router.dart';
import 'package:omgnice_ecommerce_app/features/admin/home/presentation/screens/admin_home_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/orders/presentation/screens/admin_order_detail_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/orders/presentation/screens/order_process_sceen_ad.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/screens/ad_product_list_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/screens/create_product_screen.dart';
import 'package:omgnice_ecommerce_app/features/admin/setting/presentation/screens/admin_setting_screen.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_entity.dart';

final List<GoRoute> adminRoutes = [
  GoRoute(
    path: '/admin/home',
    name: 'adminHomeScreen',
    builder: (context, state) => const AdminHomeScreen(),
  ),
  GoRoute(
    path: '/admin/product/create-product-screen',
    name: 'createProductScreen',
    builder: (context, state) => const AddProductScreen(),
  ),
  GoRoute(
    path: '/admin/product/list-product-screen',
    name: 'listProductScreen',
    builder: (context, state) => const ProductListScreen(),
  ),

  GoRoute(
      path: '/admin/order/order-detail-screen',
      name: 'orderDetailScreen',
      builder: (context, state) {
        final order = state.extra as OrderEntity;
        return AdminOrderDetailScreen(order: order);
      }),
  GoRoute(
      path: '/admin/setting/setting-screen',
      name: 'settingScreen',
      builder: (context, state) {
        return AdminSettingScreen();
      }), 

   GoRoute(
      path: '/admin/order/orderProcessing',
      name: 'orderProcessing',
      builder: (context, state) {
        return OrderProcessScreenAd(); 
      })

      //  OrderProcessScreenAd(),
  // GoRoute(
  //   path: '/admin/orders',
  //   name: 'adminOrders',
  //   builder: (context, state) => const AdminOrdersScreen(),
  // ),
];
