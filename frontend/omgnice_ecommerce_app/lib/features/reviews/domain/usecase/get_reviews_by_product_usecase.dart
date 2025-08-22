import 'package:omgnice_ecommerce_app/features/reviews/domain/entities/review_entity.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/repository/review_repository.dart';

class GetReviewsByProductUsecase {
  final ReviewRepository reviewRepository; 
  const GetReviewsByProductUsecase({
    required this.reviewRepository
  }); 
  Future<List<ReviewEntity>> execute(int product_id) async {
    return reviewRepository.getReviewProduct(product_id); 
  }
}