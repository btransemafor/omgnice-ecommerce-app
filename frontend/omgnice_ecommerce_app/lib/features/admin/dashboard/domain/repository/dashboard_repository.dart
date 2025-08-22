// DashboardRepository.dart (Interface)
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/category_category.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/dashboard_entity.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/revenue_by_day.dart';

abstract class DashboardRepository {
  Future<List<ProductCategory>> getStatisticCategory(DateTime fromDate, DateTime toDate);
 Future<List<RevenueByDay>>GetRevenueTrendByDaterange(DateTime fromDate, DateTime toDate); 
  Future<DashboardEntity> getDashboardData({required String from, required String to});
}
