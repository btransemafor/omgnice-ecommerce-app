import 'package:omgnice_ecommerce_app/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<List<ReviewEntity>> getReviewProduct(int product_id); 
  Future<bool> createReview(Map<String,String> review); 
}