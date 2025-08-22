import 'package:flutter/foundation.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/usecase/get_dashboard_overview_usease.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardProvider with ChangeNotifier {
  final GetDashboardDataUsecase getDashboardDataUsecase;

  DashboardProvider(this.getDashboardDataUsecase);

  DashboardEntity? _dashboardData;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardEntity? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> fetchDashboardData({required String from, required String to}) async {
  print('Đang gọi PROVIDER ...');

  _isLoading = true;
  _errorMessage = null;
  notifyListeners(); // báo là đang loading

  try {
    final result = await getDashboardDataUsecase.call(from: from, to: to);

    // So sánh dữ liệu mới với cũ nếu cần
    final isDifferent = result != _dashboardData;

    _dashboardData = result;

    if (isDifferent) {
      notifyListeners(); // chỉ notify nếu thực sự khác
    }

    print("OMGNIE");
    print(_dashboardData);

  } catch (e) {
    _errorMessage = e.toString();
    notifyListeners(); // báo lỗi nếu cần UI xử lý
  } finally {
    _isLoading = false;
    notifyListeners(); // để ẩn loading
  }
}

void reset() {
  _dashboardData = null;
  _isLoading = false;
  _errorMessage = null;
  notifyListeners();
}

Future<void> reload({required String from, required String to}) async {
  
  debugPrint('DashboardProvider: reload called with from=$from, to=$to');
  // ... existing reload logic
  reset();
  await fetchDashboardData(from: from, to: to);
}

}