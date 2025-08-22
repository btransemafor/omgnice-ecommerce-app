
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/category_category.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/repository/dashboard_repository.dart';

class GetStatisticCategory {
  final DashboardRepository repository;

  GetStatisticCategory({required this.repository});

  Future<List<ProductCategory>> execute(DateTime fromDate, DateTime toDate) async {
    print('Dang goi cho usecase ne .....');
    return await repository.getStatisticCategory(fromDate, toDate);
  }
}
