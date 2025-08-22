import 'package:omgnice_ecommerce_app/features/home/domain/entities/banner_entity.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/repositories/home_repository.dart';

class CreateBannerUsecase {
  final HomeRepository repository;
  CreateBannerUsecase({required this.repository}); 
  Future<bool> call (BannerEntity newBanner) async {
    return repository.createBanner(newBanner); 
  }
  
}