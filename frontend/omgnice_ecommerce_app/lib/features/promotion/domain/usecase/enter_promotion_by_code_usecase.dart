
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';

class EnterPromotionByCodeUsecase {
  final PromotionRepository promotionRepository;

  const EnterPromotionByCodeUsecase({required this.promotionRepository});

  Future<PromotionEntity> call(String code) async {
    try {
      final promotion = await promotionRepository.SearchApplyPromotionByCode(code);
        print("======================== GET PROMOTION USECASE ${promotion}"); 
      return promotion;
    
    } catch (e) {
      throw Exception('Không thể lấy mã khuyến mãi: $e');
    }
  }
}
