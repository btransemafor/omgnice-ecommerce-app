import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/pages/order_cancel_screen.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/pages/order_deliveried_screen.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/pages/order_processing_screen.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //late List<Order> orders = []; // Khởi tạo rỗng để tránh lỗi null

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Gọi usecase, dữ liệu sẽ được load sau và notify UI
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().order;
    return Scaffold(
      appBar: CustomAppBar(
          tabController:
              _tabController), //  Truyền TabController đã được khởi tạo
      backgroundColor: Colors.grey.shade200,
      body: TabBarView(
        controller: _tabController, //  Sử dụng đúng TabController
        physics: BouncingScrollPhysics(),
        children: [
          OrderProcessingScreen(), 
          OrderDeliveriedScreen(),
          OrderCancelScreen()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
