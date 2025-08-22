import 'package:omgnice_ecommerce_app/features/home/data/models/banner_model.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/entities/banner_entity.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/repositories/home_repository.dart';
import '../data_sources/home_remote_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteSource remoteSource;

  const HomeRepositoryImpl({required this.remoteSource});

  @override
  Future<List<BannerEntity>> getBanners() async {
    try {
      final models =
          await remoteSource.getBanners(); // trả về List<BannerModel>
      return models; // vì BannerModel kế thừa BannerEntity
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> canSpinToday() async {
    return await remoteSource.canSpinToday();
  }

  @override
  Future<bool> createBanner(BannerEntity newBanner) async {
    try {
      // convert to model
      BannerModel bannerModel = BannerModel(
          title: newBanner.title,
          imageUrl: newBanner.imageUrl,
          productId: newBanner.productId,
          categoryId: newBanner.categoryId,
          actionType: newBanner.actionType,
          actionValue: newBanner.actionValue ?? ' ',
          isLuckyWheelBanner: newBanner.isLuckyWheelBanner,
          startTime: newBanner.startTime,
          endTime: newBanner.endTime);
      return await remoteSource.createBanner(bannerModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteBanner(int bannerId) {
    return remoteSource.deleteBanner(bannerId);
  }
}
