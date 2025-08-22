import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/repository/dashboard_repository.dart';
import '../../domain/entities/dashboard_entity.dart';

class GetDashboardDataUsecase {
  final DashboardRepository dashboardRepository;

  GetDashboardDataUsecase({required this.dashboardRepository});

  Future<DashboardEntity> call({required String from, required String to}) async {
    return await dashboardRepository.getDashboardData(from: from, to: to);
  }
}