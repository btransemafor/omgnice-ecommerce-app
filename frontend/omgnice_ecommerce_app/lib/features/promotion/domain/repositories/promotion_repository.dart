import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';

abstract class PromotionRepository {
  Future<List<PromotionEntity>> fetchPromotions(); 
  Future<bool> saveUserPromotion(int promotion_id, {bool? isPrivate}); 
  Future<List<PromotionEntity>> getPromotions(); 
  Future<List<PromotionEntity>> getPrivatePromotions(); 
  Future<bool> createPromotion(PromotionEntity promotion, [String? is_manual]);
  Future<PromotionEntity> SearchApplyPromotionByCode(String code); 
  Future<bool> sendPromotionForUser(int promotion_id, String user_id); 
}