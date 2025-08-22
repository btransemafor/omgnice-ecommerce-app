
import 'package:omgnice_ecommerce_app/features/products/domains/repositories/category_repository.dart';
import '../data_sources/category_remote_source.dart';
import '../../domains/entities/caterogy.dart';
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteSource categoryRemoteSource;

  const CategoryRepositoryImpl({required this.categoryRemoteSource});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      return await categoryRemoteSource.getCategories();
    } catch (error) {
      print("Lỗi ở CategoryRepositoryImpl: $error");
      rethrow;
    }
  }
}
