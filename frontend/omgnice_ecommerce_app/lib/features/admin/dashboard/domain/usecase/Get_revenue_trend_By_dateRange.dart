import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/revenue_by_day.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/repository/dashboard_repository.dart';

class GetRevenueTrendByDaterange {
  final DashboardRepository dashboardRepository; 
  const GetRevenueTrendByDaterange({required this.dashboardRepository}); 
  Future<List<RevenueByDay>> execute(DateTime fromDate, DateTime toDate) async {
    print('Dang goi cho usecase ne .....');
    return await dashboardRepository.GetRevenueTrendByDaterange(fromDate, toDate); 
  }
}