import 'package:omgnice_ecommerce_app/features/home/domain/entities/banner_entity.dart';
import '../repositories/home_repository.dart';

class GetBannersUseCase {
  final HomeRepository repository;

  GetBannersUseCase({required this.repository});

  Future<List<BannerEntity>> call() {
    return repository.getBanners();
  }
}
