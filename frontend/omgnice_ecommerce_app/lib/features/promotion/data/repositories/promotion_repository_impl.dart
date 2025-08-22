// ignore_for_file: avoid_print

import 'package:omgnice_ecommerce_app/features/promotion/data/models/promotion_model.dart';
import 'package:omgnice_ecommerce_app/features/promotion/data/source/promotion_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/repositories/promotion_repository.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  final PromotionRemoteSource promotionRemoteSource;
  const PromotionRepositoryImpl({required this.promotionRemoteSource});

  Future<List<PromotionEntity>> fetchPromotions() async {
    try {
      print("DEBUG: Getting Data from Repository..... ");
      return await promotionRemoteSource.fetchPromotions();
    } catch (error) {
      rethrow;
    }
  }
  @override
  Future<bool> saveUserPromotion(int promotion_id, {bool? isPrivate}) async {
    try {
      //print("ĐANG XỬ LÝ CHỔ REPOSITORY TRONG TẦNG DATADATA");
      return await promotionRemoteSource.saveUserPromotion(promotion_id, isPrivate: isPrivate);
    } catch (error) {
      //print("ERROR no the goi toi api ");
      rethrow;
    }
  }

  // Lấy tất cả khuyến mãi
  @override
  Future<List<PromotionEntity>> getPromotions() async {
    try {
      print("DEBUG: Getting Data from Repository..... ");
      return await promotionRemoteSource.getPromotions();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> createPromotion(PromotionEntity promotion,
      [String? is_manual]) async {
    try {
      print("DEBUG: Create Promotion from Repository.....");
      print("Convert into model");

      // Validate required fields
      if (promotion.discountType == null) {
        throw Exception('Discount type is required but was null');
      }
      if (promotion.startDate == null) {
        throw Exception('Start date is required but was null');
      }
      if (promotion.endDate == null) {
        throw Exception('End date is required but was null');
      }

      // Debug: Inspect the PromotionEntity
      print('PromotionEntity Data:');
      print('Title: ${promotion.title}');
      print('Discount Type: ${promotion.discountType}');
      print('Start Date: ${promotion.startDate}');
      print('End Date: ${promotion.endDate}');

      PromotionModel promotionModel = PromotionModel(
        code: promotion.code,
        title: promotion.title,
        description: promotion.description,
        discountType: promotion.discountType, // Add discountType
        discountValue: promotion.discountValue,
        maxDiscountValue: promotion.maxDiscountValue,
        minOrderValue: promotion.minOrderValue,
        appliesTo: promotion.appliesTo,
        productId: promotion.productId,
        categoryId: promotion.categoryId,
        startDate: promotion.startDate,
        endDate: promotion.endDate,
        usageLimit: promotion.usageLimit,
        usedCount: promotion.usedCount,
        isActive: promotion.isActive,
        isExclusive: promotion.isExclusive ?? false, // Default to false if not provided
      );

      return await promotionRemoteSource.createPromotion(
          promotionModel, is_manual);
    } catch (error) {
      print('Error in PromotionRepositoryImpl.createPromotion: $error');
      rethrow;
    }
  }

  @override
  Future<PromotionEntity> SearchApplyPromotionByCode(String code) async {
    try {
      final PromotionModel? model =
          await promotionRemoteSource.SearchApplyPromotionByCode(code);
      if (model == null) {
        throw Exception('Promotion not found for code: $code');
      }
      print(model);
      return model;
    } catch (error) {
      print('Error in PromotionRepositoryImpl.SearchCode: $error');
      rethrow;
    }
  }

  @override
  Future<List<PromotionEntity>> getPrivatePromotions() async {
     try {
      print("DEBUG: Getting Data Private Promotion from Repository..... ");
      return await promotionRemoteSource.getPrivatePromotions();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> sendPromotionForUser(int promotion_id, String user_id) async {
    return await promotionRemoteSource.sendPromotionForUser(promotion_id, user_id);
  }


}
