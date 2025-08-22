import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';

class SendPromotionUsecase {
  final PromotionRepository promotionRepository; 
  const SendPromotionUsecase({required this.promotionRepository}); 
  Future<bool> call(int promotion_id, String user_id) async {
    return await promotionRepository.sendPromotionForUser(promotion_id, user_id); 
  }
}