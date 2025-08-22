import 'package:omgnice_ecommerce_app/features/home/domain/entities/banner_entity.dart';

abstract class HomeRepository {
  /// Load Banner From Firebase Store
  /// Trả về list Banner
  Future<List<BannerEntity>> getBanners();
  // Spin
  Future<bool> canSpinToday();
  Future<bool> createBanner(BannerEntity newBanner);
  Future<bool> deleteBanner(int bannerId);
}
