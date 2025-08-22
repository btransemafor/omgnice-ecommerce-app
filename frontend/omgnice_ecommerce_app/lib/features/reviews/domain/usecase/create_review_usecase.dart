import 'package:omgnice_ecommerce_app/features/reviews/domain/repository/review_repository.dart';
import 'package:omgnice_ecommerce_app/features/reviews/presentation/provider/review_provider.dart';

class CreateReviewUsecase {
  final ReviewRepository reviewRepository;
  const CreateReviewUsecase({required this.reviewRepository});
  Future<bool> createReview(Map<String, String> review) async {
    return await reviewRepository.createReview(review);
  }
}
