import 'package:omgnice_ecommerce_app/features/promotion/data/source/promotion_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';

class SaveUserpromotionUsecase {
  final PromotionRepository promotionRepository; 
  const SaveUserpromotionUsecase({required this.promotionRepository}); 

  Future<bool> call(int promotion_id , [bool? isPrivate]) async {
    return promotionRepository.saveUserPromotion(promotion_id, isPrivate: isPrivate); 
  }
}