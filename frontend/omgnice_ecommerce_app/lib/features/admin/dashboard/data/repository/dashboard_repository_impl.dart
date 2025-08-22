// DashboardRepositoryImpl.dart

import 'package:omgnice_ecommerce_app/features/admin/dashboard/data/source/dashboard_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/category_category.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/dashboard_entity.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/revenue_by_day.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteSource dashboardRemoteSource;

  DashboardRepositoryImpl({required this.dashboardRemoteSource});

  @override
  Future<List<ProductCategory>> getStatisticCategory(DateTime fromDate, DateTime toDate) async {
    return await dashboardRemoteSource.getStatisticCategory(fromDate, toDate);
  }

  @override
  Future<List<RevenueByDay>> GetRevenueTrendByDaterange(DateTime fromDate, DateTime toDate) async {
    return await dashboardRemoteSource.GetRevenueTrendByDaterange(fromDate, toDate);
  }

  @override
   Future<DashboardEntity> getDashboardData({required String from, required String to}) async {
    print("Dang load Overivew ...."); 
    final dashboardModel = await dashboardRemoteSource.fetchDashboardData(from: from, to: to);
    print(dashboardModel);
    return DashboardEntity(totalOrders: 
    dashboardModel.totalOrders, 
    processingOrders: dashboardModel.processingOrders, 
    completedOrders: dashboardModel.completedOrders, totalCustomers: dashboardModel.totalCustomers, totalRevenue: dashboardModel.totalRevenue, orderValueTotal: dashboardModel.orderValueTotal) ; 
   }
 
}
