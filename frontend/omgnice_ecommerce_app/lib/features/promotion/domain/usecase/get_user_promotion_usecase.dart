import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';

class GetUserPromotionUsecase {
  final PromotionRepository promotionRepository; 
  const GetUserPromotionUsecase({required this.promotionRepository}); 
  Future<List<PromotionEntity>> call() async {
    final data = await promotionRepository.getPromotions(); 
    return data;
  }
}