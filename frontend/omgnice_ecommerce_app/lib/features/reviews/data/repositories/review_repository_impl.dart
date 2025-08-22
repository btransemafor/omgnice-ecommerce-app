import 'package:omgnice_ecommerce_app/features/reviews/data/source/review_remote_source_impl.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/entities/review_entity.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/repository/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteSource remoteSource; 
  ReviewRepositoryImpl({
    required this.remoteSource
  }); 

  @override
  Future<List<ReviewEntity>> getReviewProduct(int product_id) async {
    return remoteSource.getReviews(product_id); 
  }
  @override
  Future<bool> createReview(Map<String,String> review) async {
    return await remoteSource.createReview(review); 
  }
} 