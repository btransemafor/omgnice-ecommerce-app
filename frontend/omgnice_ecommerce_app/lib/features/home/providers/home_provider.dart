// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/home/data/models/banner_model.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/entities/banner_entity.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/usecase/create_banner_usecase.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/usecase/delete_banner_usecase.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/usecase/spin_usecase.dart';
import 'package:omgnice_ecommerce_app/features/home/domain/usecase/get_banners_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final GetBannersUseCase getBannersUseCase;
  final CheckSpinPermissionUseCase checkSpinPermissionUseCase;
  final CreateBannerUsecase createBannerUsecase;
  final DeleteBannerUsecase deleteBannerUsecase;

  HomeProvider({
    required this.getBannersUseCase,
    required this.checkSpinPermissionUseCase,
    required this.createBannerUsecase,
    required this.deleteBannerUsecase,
  }) {
    print('⚡ HomeProvider initialized at ${DateTime.now().toIso8601String()}');
    print('⚡ getBannersUseCase: ${getBannersUseCase.runtimeType}');
    print(
        '⚡ checkSpinPermissionUseCase: ${checkSpinPermissionUseCase.runtimeType}');
    print('⚡ createBannerUsecase: ${createBannerUsecase.runtimeType}');
    print('⚡ deleteBannerUsecase: ${deleteBannerUsecase.runtimeType}');
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<BannerEntity> _banners = [];
  List<BannerEntity> get banners => _banners;

  Future<void> loadBanners() async {
    _isLoading = true;
    notifyListeners();
    try {
      _banners = await getBannersUseCase.call();
      print('⚡ Loading banners...');
      for (var banner in _banners) {
        print('⚡ Banner: ${banner.imageUrl}');
      }
    } catch (e) {
      print('⚡ Error loading banners: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isSuccess = false;
  bool isCheckingSpin = false;

  Future<bool> canSpin() async {
    isCheckingSpin = true;
    notifyListeners();
    try {
      isSuccess = await checkSpinPermissionUseCase.call();
    } catch (error) {
      print('⚡ Error checking spin: $error');
      isSuccess = false;
    } finally {
      isCheckingSpin = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> createBanner(BannerEntity newBanner) async {
    _isLoading = true;
    notifyListeners();
    bool isSuccess = false;
    print(
        'Creating banner: ${newBanner.title}, Product ID: ${newBanner.productId}');
    try {
      isSuccess = await createBannerUsecase.call(newBanner);
      // Cap nhat o client
      if (isSuccess) {
        _banners.add(BannerModel.fromEntity(newBanner));

        print("Da cap nhat local thanh cong");
        print(_banners.length);
        notifyListeners();
      }
      print('Create banner ${isSuccess ? 'succeeded' : 'failed'}');
    } catch (error) {
      print('LỖI --- KHÔNG THỂ TẠO ĐƯỢC BANNER: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> deleteBanner(int bannerId) async {
    _isLoading = true;
    notifyListeners();
    try {
      print('HomeProvider: Initiating delete for banner ID: $bannerId');
      if (deleteBannerUsecase == null) {
        print('FATAL: deleteBannerUsecase is null');
        throw Exception('DeleteBannerUsecase not initialized');
      }
      isSuccess = await deleteBannerUsecase(bannerId);
      // Cap nhat o client
      if (isSuccess) {
        // Cập nhật danh sách local nếu xóa thành công
        final index = _banners.indexWhere((item) => item.id == bannerId);
        if (index != -1) {
          _banners.removeAt(index);
          print("Đã xóa banner ở local thành công");
        }
      }
      print(
          'HomeProvider: Delete banner ${isSuccess ? 'succeeded' : 'failed'}');
    } catch (e) {
      print('Delete banner error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }
}
