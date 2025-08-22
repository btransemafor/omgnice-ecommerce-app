import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';

class CreatePromotionUsecase {
  final PromotionRepository promotionRepository; 
  const CreatePromotionUsecase({required this.promotionRepository}); 

  Future<bool> execute(PromotionEntity promotion, [String? is_manual]) async {
    try {
      print("DEBBUG đang chuẩn bị tạo promotion - USECASE"); 
     return  await promotionRepository.createPromotion(promotion, is_manual);
    }
    catch(error) {
      rethrow; 
    }
  }
}