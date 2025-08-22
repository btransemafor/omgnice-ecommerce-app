import 'package:omgnice_ecommerce_app/features/home/domain/repositories/home_repository.dart';

class DeleteBannerUsecase {
  final HomeRepository repository;

  DeleteBannerUsecase({required this.repository});

  Future<bool> call(int bannerId) async {
    print('⚡ DeleteBannerUsecase: Calling delete for banner ID: $bannerId');
    return await repository.deleteBanner(bannerId);
  }
}