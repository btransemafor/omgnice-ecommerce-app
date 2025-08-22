import 'package:omgnice_ecommerce_app/features/products/domains/entities/caterogy.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/repositories/category_repository.dart';

class GetCategoriesUsecase {
  final CategoryRepository categoryRepository;
  const GetCategoriesUsecase({required this.categoryRepository});

  Future<List<CategoryModel>> getCategories() async  {
    return await categoryRepository.getCategories();
  }
}