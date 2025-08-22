import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';

class FetchPromotionUsecase {
  final PromotionRepository promotionRepository; 
  const FetchPromotionUsecase({required this.promotionRepository}); 

  Future<List<PromotionEntity>> call() async {
    return await promotionRepository.fetchPromotions(); 
  }
}