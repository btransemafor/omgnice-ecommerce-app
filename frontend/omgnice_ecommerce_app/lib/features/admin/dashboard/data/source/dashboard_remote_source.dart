import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/data/model/dashboard_model.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/category_category.dart';
import 'package:omgnice_ecommerce_app/features/admin/dashboard/domain/entities/revenue_by_day.dart';

abstract class DashboardRemoteSource {
  Future<List<ProductCategory>> getStatisticCategory(
      DateTime fromDate, DateTime toDate);
  Future<List<RevenueByDay>> GetRevenueTrendByDaterange(
      DateTime fromDate, DateTime toDate);
  Future<DashboardModel> fetchDashboardData(
      {required String from, required String to});
}

class DashboardRemoteSourceImpl implements DashboardRemoteSource {
  final Dio dio;

  DashboardRemoteSourceImpl({required this.dio});

  @override
  Future<List<ProductCategory>> getStatisticCategory(
      DateTime fromDate, DateTime toDate) async {
    print('Đang gọi tới server...');
    final queryParams = {
      'from': fromDate.toIso8601String().split('T').first,
      'to': toDate.toIso8601String().split('T').first,
    };

    try {
      final response = await dio.get(
        '/admin/statistics/category',
        queryParameters: queryParams,
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => ProductCategory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e\n$stackTrace');
      throw Exception('Error fetching statistics: $e');
    }
  }

  @override
  Future<List<RevenueByDay>> GetRevenueTrendByDaterange(
      DateTime fromDate, DateTime toDate) async {
    print('Đang gọi tới server...');
    final queryParams = {
      'start': fromDate.toIso8601String().split('T').first,
      'end': toDate.toIso8601String().split('T').first,
    };

    try {
      final response = await dio.get(
        '/admin/statistics/revenue-last7Days',
        queryParameters: queryParams,
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print(data);
        return data.map((json) => RevenueByDay.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e\n$stackTrace');
      throw Exception('Error fetching statistics: $e');
    }
  }

  @override
  Future<DashboardModel> fetchDashboardData(
      {required String from, required String to}) async {
    print("Dang goi toi server để load overvieư");
    final response = await dio.get(
      '/admin/statistics/dashboard-overview?from=$from&to=$to',
    );

    print(response.statusCode);
    print(response.data);
    final data = response.data;

    if (response.statusCode == 200) {
      return DashboardModel(
          completedOrders: data['completedOrders'],
          totalCustomers: data['totalCustomers'],
          totalOrders: data['totalOrders'],
          processingOrders: data['processingOrders'],
          orderValueTotal: data['orderValueTotal'],
          totalRevenue: data['totalRevenue']);
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}
