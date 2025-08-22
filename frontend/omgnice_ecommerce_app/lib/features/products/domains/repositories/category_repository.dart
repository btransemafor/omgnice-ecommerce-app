import 'package:omgnice_ecommerce_app/features/products/domains/entities/caterogy.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();
}