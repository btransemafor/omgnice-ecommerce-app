// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/create_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/enter_promotion_by_code_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/fetch_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/get_private_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/get_user_promotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/save_userPromotion_usecase.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/usecase/send_promotion_usecase.dart';

class PromotionProvider extends ChangeNotifier {
  final FetchPromotionUsecase fetchPromotionUsecase;
  final SaveUserpromotionUsecase saveUserPromotionUsecase;
  final GetUserPromotionUsecase getUserPromotionUsecase;
  final CreatePromotionUsecase createPromotionUsecase;
  final EnterPromotionByCodeUsecase enterPromotionByCodeUsecase;
  final GetPrivatePromotionUsecase getPrivatePromotionUsecase;
  final SendPromotionUsecase sendPromotionUsecase;

  PromotionProvider(
      {required this.fetchPromotionUsecase,
      required this.saveUserPromotionUsecase,
      required this.getUserPromotionUsecase,
      required this.createPromotionUsecase,
      required this.enterPromotionByCodeUsecase,
      required this.getPrivatePromotionUsecase,
      required this.sendPromotionUsecase});

  List<PromotionEntity> _promotions = [];
  List<PromotionEntity> _userPromotions = [];
  PromotionEntity? _selectedPromotion;
  bool _isLoading = false;
  String? _error;
  bool _isSuccess = false;

  bool get isSuccess => _isSuccess;

  List<PromotionEntity> get promotions => _promotions;
  List<PromotionEntity> get userPromotions => _userPromotions;

  PromotionEntity? get selectedPromotion => _selectedPromotion;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<PromotionEntity> _privatePromotions = [];
  List<PromotionEntity> get privatePromotions => _privatePromotions;

  // Filter

  String filterStatus = "All";
  List<PromotionEntity> filterPromotions(String filterStatus) {
    if (filterStatus == 'All') {
      return userPromotions;
    } else if (filterStatus == 'Expiring Soon') {
      // Get now Date
      final now = DateTime.now();
      // Tìm khoảng giữa ngày hiện tại với endDate của voucher
      return userPromotions.where((item) {
        final daysremaining = item.endDate!.difference(now).inDays;
        return daysremaining <= 7 && daysremaining >= 0;
      }).toList();
    }
    return userPromotions;
  }

  void setFilter(String status) {
    filterStatus = status;
    notifyListeners();
  }

  /// Gọi API để lấy danh sách khuyến mãi
  Future<void> fetchPromotions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _promotions = await fetchPromotionUsecase.call();
      print("FETCH DATA PROMOTION SUCCESSFULLY");
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPrivatePromotions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _privatePromotions = await getPrivatePromotionUsecase.call();
      print("FETCH DATA PROMOTION Private SUCCESSFULLY");
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Chọn 1 promotion
  void selectPromotion(PromotionEntity promotion) {
    _selectedPromotion = promotion;

    print(_selectedPromotion!.description);
    notifyListeners();
  }

  /// Xóa promotion đã chọn
  void clearPromotion() {
    _selectedPromotion = null;
    notifyListeners();
  }

  /// Tính giá sau khi áp dụng mã giảm
  double applyDiscount(double orderTotal) {
    if (_selectedPromotion == null) return orderTotal;

    final promo = _selectedPromotion!;
    if (promo.discountType == 'PERCENTAGE') {
      final discount = orderTotal * (promo.discountValue ?? 0) / 100;
      final cappedDiscount = (promo.maxDiscountValue != null)
          ? discount.clamp(0, promo.maxDiscountValue!)
          : discount;
      return orderTotal - cappedDiscount;
    } else if (promo.discountType == 'FIXED') {
      return orderTotal - (promo.discountValue ?? 0);
    }
    return orderTotal;
  }

  /// -------------- USER -------------------------//
  // Save Promotion User
/*   Future<bool> saveUserPromotion(int promotionId, [bool? isPrivate]) async {
    _isLoading = true;
    _isSuccess = false;
    try {
      print("Luu Promotion"); 
      final promotion =
          _promotions.firstWhere((item) => item.id == promotionId);
      _isSuccess = await saveUserPromotionUsecase.call(promotionId);

      if (_isSuccess == true) {
        print(_isSuccess);
        updateUsedCount(promotion);
        _error = null;
      } else {
        _error = 'Failed to save promotion';
        _isSuccess = false;
      }
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  } */

 Future<bool> saveUserPromotion(int promotionId, [bool? isPrivate]) async {
  _isLoading = true;
  _isSuccess = false;
  try {
    print("Luu Promotion");
    if (isPrivate != true) { // Chỉ kiểm tra _promotions nếu isPrivate không phải true
      final promotion = _promotions.firstWhere((item) => item.id == promotionId);
    }
    _isSuccess = await saveUserPromotionUsecase.call(promotionId);

    if (_isSuccess == true) {
      print(_isSuccess);
      if (isPrivate != true) { // Cập nhật usedCount chỉ khi isPrivate không phải true
        final promotion = _promotions.firstWhere((item) => item.id == promotionId);
        updateUsedCount(promotion);
      }
      _error = null;
    } else {
      _error = 'Failed to save promotion';
      _isSuccess = false;
    }
  } catch (error) {
    _error = error.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
  return _isSuccess; // Sửa lại thành _isSuccess thay vì isSuccess
}



  Future<void> GetUserPromotion() async {
    _isSuccess = false;
    _isLoading = true;
    notifyListeners();

    try {
      _userPromotions = await getUserPromotionUsecase.call();

      if (_userPromotions.isNotEmpty) {
        _isSuccess = true;
        print("Số lượng promotion: ${_userPromotions.length}");
        for (var promo in _userPromotions) {
          print(promo.description); // Kiểm tra mô tả của mỗi promotion
        }
      }
    } catch (error) {
      _isSuccess = false;
      print("Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateUsedCount(PromotionEntity promotion) {
    promotion.usedCount = (promotion.usedCount ?? 0) + 1;
    notifyListeners();
  }

  ////////// --------- FEATURE USECASE ----------------- /////////
  ///
  Future<void> createPromotion(PromotionEntity promotion,
      [String? is_manual]) async {
    _isLoading = true;
    notifyListeners();
    try {
      print("DEBUG - Đang tiến hành tạo promotion né - PROVIDER");
      _isSuccess = await createPromotionUsecase.execute(promotion, is_manual);
    } catch (error) {
      _isSuccess = false;
      print("Loi $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendPromotionForUser(int promotion_id, String user_id) async {
    _isLoading = true; 
    notifyListeners(); 
    bool isSuccess = false; 
    try {
      isSuccess = await sendPromotionUsecase.call(promotion_id, user_id); 
    }
    catch(error) {
    throw("Error xảy ra!"); 
    }
    finally {
      _isLoading = false; 
      notifyListeners(); 
    }
    return isSuccess;
  }
  // Search and Apply
  Future<PromotionEntity?> SearchPromotion(String code) async {
    PromotionEntity? searchedPromotion;
    _isLoading = true;
    notifyListeners();
    try {
      searchedPromotion = await enterPromotionByCodeUsecase.call(code);
      print(
          "============== GET THANH CÔNG PROMOTION KHÔNG ? ${selectedPromotion}");
      _error = null;
    } catch (error) {
      _error = '$error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    if (searchedPromotion != null) {
      _selectedPromotion = searchedPromotion;
      notifyListeners();
      return searchedPromotion;
    } else {
      throw Exception('Promotion not found');
    }
  }
}
