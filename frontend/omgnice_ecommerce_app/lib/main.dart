import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/core/app_router.dart';
import 'package:omgnice_ecommerce_app/core/common_theme.dart';
import 'package:omgnice_ecommerce_app/core/di/injection.dart';
import 'package:omgnice_ecommerce_app/core/network/token_manager.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/provider/admin_product_provider.dart';
import 'package:omgnice_ecommerce_app/features/app-state/representation/providers/app_state_provider.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/provider/favorite_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/location_provider_over.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:omgnice_ecommerce_app/features/payment/presentation/provider/payment_provider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:omgnice_ecommerce_app/features/reviews/presentation/provider/review_provider.dart';
import './features/orders/order_exports.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zalo_flutter/zalo_flutter.dart';
import 'features/home/home.dart';
import 'features/cart/cart_exports.dart';
import 'features/products/product_exports.dart';
import 'features/auth/auth_export.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/profile/profile_export.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart'
    as user;
import 'firebase_options.dart';

//import 'package:zalo_flutter/zalo_flutter.dart';
// Tạo một GlobalKey để quản lý ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  // 1. Khởi tạo Flutter binding TRƯỚC TIÊN
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Khởi tạo Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());
  await Hive.openBox<CartItemModel>('cartBox');

  final hashKey = await ZaloFlutter.getHashKeyAndroid();
  debugPrint("Zalo HashKey: $hashKey");

  // 3. Khởi tạo Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase đã khởi tạo thành công!");
  } else {
    Firebase.app(); // Sử dụng app đã được khởi tạo
    print("Firebase đã được khởi tạo trước đó.");
  }
  await TokenManager.loadTokensFromStorage();
  // 5. Khởi tạo dependencies
  await initDependencies();
  // 6. Khởi tạo các provider
  final appStateProviders = await AppStateProvider.getProviders();
  final locationProvider = await LocationProviderOver.getLocationProvider();
  final addressProvider = await AddressProviderOver.getAddressProvider();
  // 7. Khởi tạo các service và usecase
  // final dio = Dio();
  //  Home Dependencies
  final homeRemoteDataSource = HomeRemoteSourceImpl();
  final homeRepository = HomeRepositoryImpl(remoteSource: homeRemoteDataSource);
  final getBannersUseCase = GetBannersUseCase(repository: homeRepository);
  final checkSpinPermission = CheckSpinPermissionUseCase(homeRepository);
  final createBannerUsecase = CreateBannerUsecase(repository: homeRepository);
  final deleteBanner = DeleteBannerUsecase(repository: homeRepository);
  final categoryRemoteSource = CategoryRemoteSourceImpl();
  final categoryRepositoryImpl =
      CategoryRepositoryImpl(categoryRemoteSource: categoryRemoteSource);
  final getCategoriesUseCase =
      GetCategoriesUsecase(categoryRepository: categoryRepositoryImpl);
  final productRemoteSourceImpl = ProductRemoteSourceImpl();
  final productRepositoryImpl =
      ProductRepositoryImpl(productRemoteSource: productRemoteSourceImpl);
  final getProductsByCategoryUseCase =
      GetProductsByCategoryUsecase(productRepository: productRepositoryImpl);
  final getProductByIdUseCase =
      GetProductDetailUsecase(productRepository: productRepositoryImpl);
  final searchProductUsecase =
      SearchProductUsecase(productRepository: productRepositoryImpl);
  final cartRemoteSourceImpl = CartRemoteSourceImpl();
  final cartLocalDS = CartLocalDataSource();
  final cartRepositoryImpl = CartRepositoryImpl(
      cartRemoteSource: cartRemoteSourceImpl, cartLocalDataSource: cartLocalDS);
  final getCartUsecase = GetCartUsecase(cartRepository: cartRepositoryImpl);
  final deleteItemCartUsecase =
      DeleteItemcartUsecase(cartRepository: cartRepositoryImpl);
  final addToCartUsecase = AddToCartUsease(cartRepository: cartRepositoryImpl);
  final updateCartItemUsecase =
      UpdateCartItemUsecase(cartRepository: cartRepositoryImpl);
  final shippingmedRemoteSourceImpl = ShippingRemoteSourceImpl();
  final shippingRepositoryImpl =
      ShippingRepositoryImpl(shippingRemoteSource: shippingmedRemoteSourceImpl);
  final getShippingMethod =
      GetShippingUsecase(shippingRepository: shippingRepositoryImpl);
  final orderRemoteSource = OrderRemoteSourceImpl();
  final orderRemoteSourceImpl =
      OrderRepositoryImpl(remoteSource: orderRemoteSource);
  final getOrderUsecase =
      GetOrderUsecase(orderRepository: orderRemoteSourceImpl);
  final createOrderUsecase =
      CreateOrderUsecase(orderRepository: orderRemoteSourceImpl);
  final getOrderByIdUseCase =
      GetOrderByIdUseCase(repository: orderRemoteSourceImpl);
  final fetchAllOrderUsecase =
      FetchAllOrdersUsecase(orderRepository: orderRemoteSourceImpl);
  final updateStatusOrderUsecase =
      UpdateStatusorderUsecase(orderRepository: orderRemoteSourceImpl);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl<AuthProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => sl<UserProvider>()),
        ChangeNotifierProvider(create: (_) => sl<PromotionProvider>()),
        ChangeNotifierProvider(create: (_) => OtpCountdownProvider()),
        ChangeNotifierProvider(create: (_) => sl<FavoriteProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => sl<DashboardProvider>()),
        ChangeNotifierProvider(create: (_) => sl<AdminProductProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ReviewProvider>()),
        ChangeNotifierProvider(create: (_) => sl<user.UserProvider>()),
        ChangeNotifierProvider(create: (_) => sl<NotificationProvider>()),
        ChangeNotifierProvider(
          create: (_) => sl<PaymentProvider>(),
        ),
        ChangeNotifierProvider(
            create: (_) => HomeProvider(
                deleteBannerUsecase: deleteBanner,
                getBannersUseCase: getBannersUseCase,
                checkSpinPermissionUseCase: checkSpinPermission,
                createBannerUsecase: createBannerUsecase)),
        ChangeNotifierProvider(create: (_) => ScreenManager()),
        ChangeNotifierProvider(
          create: (_) =>
              CategoryProvider(getCategoriesUseCase: getCategoriesUseCase),
        ),
        ChangeNotifierProvider(
            create: (_) => ProductProvider(
                searchProductUsecase: searchProductUsecase,
                getProductsByCategoryUC: getProductsByCategoryUseCase,
                getProductDetailUsecase: getProductByIdUseCase)),
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
        ChangeNotifierProvider(
          create: (_) => CartProvider(
              getCartUsecase: getCartUsecase,
              deleteItemcartUsecase: deleteItemCartUsecase,
              addToCartUsecase: addToCartUsecase,
              updateCartItemUsecase: updateCartItemUsecase),
        ),
        appStateProviders,
        locationProvider,
        addressProvider,
       // ChangeNotifierProvider(create: (_) => sl<OrderProvider>()),


           ChangeNotifierProvider(
            create: (_) => OrderProvider(
                updateOrderUsecase: updateStatusOrderUsecase,
                fetchAllOrdersUsecase: fetchAllOrderUsecase,
                getShippingUsecase: getShippingMethod,
                getOrderUsecase: getOrderUsecase,
                createOrderUsecase: createOrderUsecase,
                getOrderByIdUseCase: getOrderByIdUseCase)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: "E-Commerce App",
      theme: CommonTheme.lightTheme,
      routerConfig: AppRouter.router,
      //routeInformationParser: OmgRouteParser(),
    );
  }
}
