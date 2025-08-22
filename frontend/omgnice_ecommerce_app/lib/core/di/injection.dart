// lib/core/di/injection.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omgnice_ecommerce_app/core/network/dio_client.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/data/source/dashboard_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/repository/dashboard_repository.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/usecase/Get_revenue_trend_By_dateRange.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/usecase/get_dashboard_overview_usease.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/usecase/get_statistic_category.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/data/repository/admin_product_repository_impl.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/data/source/admin_product_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/repository/admin_product_repository.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/usecase/create_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/usecase/delete_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/usecase/fetch_list_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/usecase/update_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/provider/admin_product_provider.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/sources/firebase/google_sign_in_service.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/check_password_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/signin_google_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/data/repository/notification_remote_impl.dart';
import 'package:omgnice_ecommerce_app/features/notification/data/source/notification_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/create_notification_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/delete_all_notification_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/delete_notification_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/fetch_notifications_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/mark_all_noti_read_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/mark_all_notification_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/order_exports.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/create_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/enter_promotion_by_code_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/get_private_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/send_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/data/remote/user_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/repositories/user_repository.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/ad_fetch_users_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/delete_user_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/fetch_statistics_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/get_profile_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/update_point_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/usecase/update_user_usecase.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart'
    as user;
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/logout_usecase.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/usecase/reset_password_usecase.dart';
import '../../features/auth/auth_export.dart';
import 'package:omgnice_ecommerce_app/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:omgnice_ecommerce_app/features/favorites/data/source/remotes/favorite_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:omgnice_ecommerce_app/features/favorites/domain/usecase/add_favorite_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/favorites/domain/usecase/delete_favorite_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/favorites/domain/usecase/get_favorite_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/favorites/presentation/provider/favorite_provider.dart';
import 'package:omgnice_ecommerce_app/features/payment/data/repository/payment_repository_impl.dart';
import 'package:omgnice_ecommerce_app/features/payment/data/source/payment_remote_datasource.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/repository/payment_repository.dart';
import 'package:omgnice_ecommerce_app/features/payment/domain/usecase/create_payment.dart';
import 'package:omgnice_ecommerce_app/features/payment/presentation/provider/payment_provider.dart';
import 'package:omgnice_ecommerce_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:omgnice_ecommerce_app/features/profile/data/sources/remotes/profile_remote_datasource.dart';
import 'package:omgnice_ecommerce_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:omgnice_ecommerce_app/features/profile/domain/usecases/contact_us_usecase.dart';
import 'package:omgnice_ecommerce_app/features/profile/domain/usecases/update_info_usecase.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/providers/profileProvider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/data/repositories/promotion_repository_impl.dart';
import 'package:omgnice_ecommerce_app/features/promotion/data/source/promotion_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/fetch_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/get_user_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/save_userPromotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:omgnice_ecommerce_app/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:omgnice_ecommerce_app/features/reviews/data/source/review_remote_source_impl.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/repository/review_repository.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/usecase/create_review_usecase.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/usecase/get_reviews_by_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/reviews/presentation/provider/review_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/sources/local/auth_local_data_source.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Firebase init
  await Firebase.initializeApp();

  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Dio
  if (sl.isRegistered<Dio>()) {
    sl.unregister<Dio>();
  }
  sl.registerLazySingleton<Dio>(() => DioClient().client);

  // Firebase Auth & Google Sign-In
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // Auth DataSources
  sl.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSourceImpl());
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()));

  // AuthService - Google Sign-In
  sl.registerLazySingleton<AuthService>(
    () => GoogleServiceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteSource: sl(),
      localSource: sl(),
      authService: sl(),
    ),
  );

  // Auth UseCases
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOTPUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => ResendOtpUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => SigninGoogleUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => CheckPasswordUsecase(authRepository: sl()));

  // Auth Providers
  sl.registerFactory(() => AuthProvider(
        resetPasswordUsecase: sl(),
        loginuserUC: sl(),
        registerUserUC: sl(),
        verifyOTPUseCase: sl(),
        resendOtpUsecase: sl(),
        forgotPasswordUsecase: sl(),
        logoutUsecase: sl(),
        signinGoogleUsecase: sl(),
        checkPasswordUsecase: sl(),
      ));

  // ----------- ORDER ------------   //
  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(remoteSource: sl()));
  sl.registerLazySingleton<ShippingRepository>(
      () => ShippingRepositoryImpl(shippingRemoteSource: sl()));

    sl.registerLazySingleton(() => GetShippingUsecase(shippingRepository: sl()));
  sl.registerLazySingleton(() => CreateOrderUsecase(orderRepository: sl()));
  sl.registerLazySingleton(() => FetchAllOrdersUsecase(orderRepository: sl()));
  sl.registerLazySingleton(() =>  GetOrderUsecase(orderRepository: sl())); 
  sl.registerLazySingleton(() => GetOrderByIdUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => UpdateStatusorderUsecase(orderRepository: sl()));

// provider
  sl.registerFactory(() => OrderProvider(
      getShippingUsecase: sl(),
      getOrderUsecase: sl(),
      createOrderUsecase: sl(),
      getOrderByIdUseCase: sl(),
      fetchAllOrdersUsecase: sl(),
      updateOrderUsecase: sl()));

  sl.registerFactory(() => UserProvider(
        getCurrentUserUsecase: sl(),
      ));

  // Promotion
  sl.registerLazySingleton<PromotionRemoteSource>(
      () => PromotionRemoteSourceImpl());
  sl.registerLazySingleton<PromotionRepository>(
      () => PromotionRepositoryImpl(promotionRemoteSource: sl()));
  sl.registerLazySingleton(
      () => FetchPromotionUsecase(promotionRepository: sl()));
  sl.registerLazySingleton(
      () => SaveUserpromotionUsecase(promotionRepository: sl()));
  sl.registerLazySingleton(
      () => GetUserPromotionUsecase(promotionRepository: sl()));
  sl.registerLazySingleton(
      () => CreatePromotionUsecase(promotionRepository: sl()));

  sl.registerLazySingleton(
      () => EnterPromotionByCodeUsecase(promotionRepository: sl()));

  sl.registerLazySingleton(
      () => GetPrivatePromotionUsecase(promotionRepository: sl()));
  sl.registerLazySingleton(
      () => SendPromotionUsecase(promotionRepository: sl()));
  sl.registerFactory(() => PromotionProvider(
        sendPromotionUsecase: sl(),
        getPrivatePromotionUsecase: sl(),
        enterPromotionByCodeUsecase: sl(),
        createPromotionUsecase: sl(),
        fetchPromotionUsecase: sl(),
        saveUserPromotionUsecase: sl(),
        getUserPromotionUsecase: sl(),
      ));

  // Favorite
  sl.registerLazySingleton<FavoriteRemoteSource>(
      () => FavoriteRemoteSourceImpl());
  sl.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(favoriteRemoteSource: sl()));
  sl.registerLazySingleton(
      () => GetFavoriteProductUsecase(favoriteRepository: sl()));
  sl.registerLazySingleton(
      () => AddFavoriteProductUsecase(favoriteRepository: sl()));
  sl.registerLazySingleton(
      () => DeleteFavoriteProductUsecase(favoriteRepository: sl()));

  sl.registerFactory(() => FavoriteProvider(
        addFavoriteProductUsecase: sl(),
        getFavoriteProductUsecase: sl(),
        deleteFavoriteProductUsecase: sl(),
      ));

  // Profile
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(profileDataSource: sl()));
  sl.registerLazySingleton<ProfileDataSource>(
      () => ProfileRemoteDataSource(dio: sl()));

  sl.registerLazySingleton(() => UpdateInfoUsecase(profileRepository: sl()));
  sl.registerLazySingleton(() => ContactUsUsecase(profileRepository: sl()));
  sl.registerFactory(
      () => ProfileProvider(updateInfoUsecase: sl(), contactUsUsecase: sl()));

  // Dashboard
  sl.registerLazySingleton<DashboardRemoteSource>(
      () => DashboardRemoteSourceImpl(dio: sl()));
  sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(dashboardRemoteSource: sl()));
  sl.registerLazySingleton(() => GetStatisticCategory(repository: sl()));
  sl.registerLazySingleton(
      () => GetRevenueTrendByDaterange(dashboardRepository: sl()));

  // Dashboard
  //sl.registerLazySingleton<DashboardRemoteSource>(() => DashboardRemoteSourceImpl(dio: sl()));
  //sl.registerLazySingleton<DashboardRepository>(
  //() => DashboardRepositoryImpl(dashboardRemoteSource: sl()));
  //sl.registerLazySingleton(() => GetStatisticCategory(repository: sl()));
  //sl.registerLazySingleton(() => GetRevenueTrendByDaterange(dashboardRepository: sl()));

  sl.registerFactory(() => DashboardProvider(sl()));
  sl.registerLazySingleton(
      () => GetDashboardDataUsecase(dashboardRepository: sl()));

  sl.registerLazySingleton<AdminProductRemoteSource>(
      () => AdminProductRemoteImpl(dio: sl()));
  sl.registerLazySingleton<AdminProductRepository>(
      () => AdminProductRepositoryImpl(adminProductRemoteSource: sl()));

  sl.registerLazySingleton(
      () => CreateProductUsecase(adminProductRepository: sl()));
  sl.registerFactory(() => AdminProductProvider(
      createProductUsecase: sl(),
      fetchListProductUsecase: sl(),
      updateProductUsecase: sl(),
      deleteProductUsecase: sl()));
  sl.registerLazySingleton(() => FetchListProductUsecase(sl()));
  sl.registerLazySingleton(
      () => UpdateProductUsecase(adminProductRepository: sl()));
  sl.registerLazySingleton(
      () => DeleteProductUsecase(adminProductRepository: sl()));
  // Payment
  // Use cases
  sl.registerLazySingleton(() => CreatePaymentUsecase(sl()));

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(sl()),
  );

  // Providers
  sl.registerFactory(() => PaymentProvider(sl()));
  sl.registerLazySingleton<UserRemoteSource>(
      () => UserRemoteSourceImpl(dio: sl()));
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteSource: sl(), localSource: sl()));

// Đăng ký các Usecase trước
  sl.registerLazySingleton(() => FetchStatisticsUsecase(userRepository: sl()));
  sl.registerLazySingleton(() => UpdateUserUsecase(userRepository: sl()));
  sl.registerLazySingleton(() => GetProfileUsecase(userRepository: sl()));
  sl.registerLazySingleton(() => AdFetchUsersUsecase(userRepository: sl()));
  sl.registerLazySingleton(() => UpdateUserPointUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteUserUsecase(userRepository: sl()));
// Sau đó mới đăng ký Provider
  sl.registerFactory(
    () => user.UserProvider(
        deleteUserUsecase: sl(),
        adFetchUsersUsecase: sl(),
        fetchStatisticsUsecase: sl(),
        updateUserUsecase: sl(),
        getProfileUsecase: sl(),
        updateUserPointUseCase: sl()),
  );

  sl.registerSingleton<NotificationRemoteDataSource>(
    NotificationRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerSingleton<NotificationRepository>(
    NotificationRepositoryImpl(sl<NotificationRemoteDataSource>()),
  );
  sl.registerSingleton<GetNotificationsUseCase>(
    GetNotificationsUseCase(repository: sl<NotificationRepository>()),
  );
  sl.registerSingleton<MarkNotificationAsReadUseCase>(
    MarkNotificationAsReadUseCase(repository: sl<NotificationRepository>()),
  );
  sl.registerSingleton<MarkAllNotificationsAsReadUseCase>(
    MarkAllNotificationsAsReadUseCase(repository: sl<NotificationRepository>()),
  );
  sl.registerSingleton<DeleteNotificationUseCase>(
    DeleteNotificationUseCase(repository: sl<NotificationRepository>()),
  );
  sl.registerSingleton<DeleteAllNotificationsUseCase>(
    DeleteAllNotificationsUseCase(repository: sl<NotificationRepository>()),
  );
  sl.registerSingleton<CreateNotificationUsecase>(
    CreateNotificationUsecase(
        notificationRepository: sl<NotificationRepository>()),
  );
  sl.registerSingleton<MarkAllAdminNotificationsAsReadUseCase>(
    MarkAllAdminNotificationsAsReadUseCase(
        repository: sl<NotificationRepository>()),
  );

  sl.registerFactory<NotificationProvider>(
    () => NotificationProvider(
      markAllAdminNotificationsAsReadUseCase:
          sl<MarkAllAdminNotificationsAsReadUseCase>(),
      createNotificationUsecase: sl<CreateNotificationUsecase>(),
      getNotificationsUseCase: sl<GetNotificationsUseCase>(),
      markNotificationAsReadUseCase: sl<MarkNotificationAsReadUseCase>(),
      markAllNotificationsAsReadUseCase:
          sl<MarkAllNotificationsAsReadUseCase>(),
      deleteNotificationUseCase: sl<DeleteNotificationUseCase>(),
      deleteAllNotificationsUseCase: sl<DeleteAllNotificationsUseCase>(),
    ),
  );
  sl.registerLazySingleton<ReviewRemoteSource>(
      () => ReviewRemoteSourceImpl(sl()));
  sl.registerLazySingleton<ReviewRepository>(
      () => ReviewRepositoryImpl(remoteSource: sl()));

  sl.registerLazySingleton(
      () => GetReviewsByProductUsecase(reviewRepository: sl()));

  sl.registerLazySingleton(() => CreateReviewUsecase(reviewRepository: sl()));

  sl.registerFactory(() => ReviewProvider(
      getReviewsByProductUsecase: sl(), createReviewUsecase: sl()));
}
