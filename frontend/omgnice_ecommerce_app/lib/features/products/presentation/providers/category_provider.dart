import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/caterogy.dart';
import '../../domains/usecases/get_categories_usecase.dart';

class CategoryProvider extends ChangeNotifier {
  final GetCategoriesUsecase getCategoriesUseCase;

  CategoryProvider({
    required this.getCategoriesUseCase,
  });

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  // Khởi tạo với giá trị 0 (phần tử đầu tiên trong danh sách)
  int _selectedIndex = 0;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedIndex => _selectedIndex;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await getCategoriesUseCase.getCategories();
      _error = null;
    } catch (e) {
      _error = 'Không thể tải danh mục';
      print('Error fetching categories: $e'); // Thêm log để debug
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(int index) {
    // Đảm bảo index trong khoảng hợp lệ để tránh lỗi
    if (index >= 0 && index < _categories.length) {
      _selectedIndex = index;
      notifyListeners();
    } else {
      print('Invalid category index: $index. Categories length: ${_categories.length}');
    }
  }
}