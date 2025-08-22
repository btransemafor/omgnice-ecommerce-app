import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/entities/review_entity.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/usecase/get_reviews_by_product_usecase.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/usecase/create_review_usecase.dart';

class ReviewProvider extends ChangeNotifier {
  final GetReviewsByProductUsecase getReviewsByProductUsecase;
  final CreateReviewUsecase createReviewUsecase;

  ReviewProvider({
    required this.getReviewsByProductUsecase,
    required this.createReviewUsecase,
  });

  // ----- FETCH REVIEWS -----
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ReviewEntity> _reviews = [];
  List<ReviewEntity> get reviews => _reviews;

  Future<void> getReviews(int productId) async {
    print(" Fetching reviews for product: $productId");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getReviewsByProductUsecase.execute(productId);
      _reviews = result;
      _isSuccess = _reviews.isNotEmpty;
    } catch (error) {
      _isSuccess = false;
      _errorMessage = error.toString();
      print("Error while fetching reviews: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ----- CREATE REVIEW -----
  bool _isCreating = false;
  bool get isCreating => _isCreating;

  bool _createSuccess = false;
  bool get createSuccess => _createSuccess;

  String? _createError;
  String? get createError => _createError;

  Future<bool> createReview(Map<String, String> review) async {
    _isCreating = true;
    _createError = null;
    _createSuccess = false;
    notifyListeners();

    try {
      final success = await createReviewUsecase.createReview(review);
      _createSuccess = success;
      return success;
    } catch (error) {
      _createError = error.toString();
      print(' Failed to create review: $_createError');
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }
}
