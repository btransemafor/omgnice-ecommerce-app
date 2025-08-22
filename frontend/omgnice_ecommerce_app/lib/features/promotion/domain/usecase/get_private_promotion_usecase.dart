import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';

class GetPrivatePromotionUsecase {
  final PromotionRepository promotionRepository; 
  const GetPrivatePromotionUsecase({required this.promotionRepository}); 

  Future<List<PromotionEntity>> call() async {
    return await promotionRepository.getPrivatePromotions(); 
  }
}