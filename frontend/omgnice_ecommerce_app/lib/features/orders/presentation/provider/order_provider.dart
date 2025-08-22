// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/usecases/create_order_usecase.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/usecases/fetch_all_orders_usecase.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/usecases/get_order_by_id.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/usecases/get_order_usecase.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/usecases/get_shipping_usecase.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/usecases/update_statusOrder_usecase.dart';

class OrderProvider extends ChangeNotifier {
  final GetShippingUsecase getShippingUsecase;
  final GetOrderUsecase getOrderUsecase;
  final CreateOrderUsecase createOrderUsecase;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final FetchAllOrdersUsecase fetchAllOrdersUsecase;
  final UpdateStatusorderUsecase updateOrderUsecase;

  OrderProvider(
      {required this.getShippingUsecase,
      required this.getOrderUsecase,
      required this.createOrderUsecase,
      required this.getOrderByIdUseCase,
      required this.fetchAllOrdersUsecase,
      required this.updateOrderUsecase});

  List<ShippingMethodEntity> _listShipping = [];
  List<ShippingMethodEntity> get listShipping => _listShipping;

  //  Order
  List<OrderEntity> _orders = [];
  int totalQuantityItem = 0;
  List<OrderEntity> get order => _orders;

  ShippingMethodEntity? _selectShipping = ShippingMethodEntity(
      id: '01c0bd15-9a97-4ebc-a628-9a5bc696e851', name: 'Standard Shipping');
  ShippingMethodEntity? get selectShipping => _selectShipping;

  // selectedTime - Deivery_time_slot
  String? _selectedDeliveryTimeSlot = 'Deliver Now';
  String? get selectedDeliveryTimeSlot => _selectedDeliveryTimeSlot;

  String? _selectedPayment = "MoMo E-Wallet"; // mặc định nó dị á bà - tui thích
  String? get selectedPayment => _selectedPayment;

  // Lưu trữ NoteOrder - Này note tổng luôn khác với note trong từng item nha
  String? _noteOrder;
  String? get noteOrder => _noteOrder;
  void setNoteOrder(String note) {
    _noteOrder = note;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  OrderEntity? _orderByCode;
  OrderEntity? get orderByCode => _orderByCode;

  Future<void> getShipping() async {
    _isLoading = true;
    _isSuccess = false;
    _listShipping = [];
    notifyListeners(); // Cập nhật UI ngay khi loading bắt đầu

    try {
      _listShipping = await getShippingUsecase.call();
      _isSuccess = _listShipping.isNotEmpty;
    } catch (error) {
      _isSuccess = false;
      // Có thể log hoặc xử lý error thêm nếu cần
    } finally {
      _isLoading = false;
      notifyListeners(); // Cập nhật lại trạng thái sau khi xong
    }
  }

  ShippingMethodEntity? dedaultShippingMethod() {
    if (_selectShipping != null) return _selectShipping;

    try {
      final defaultItem = _listShipping.firstWhere(
        (item) => item.name == 'Standard Shipping',
      );
      _selectShipping = defaultItem; // Cập nhật để các nơi khác dùng được
      return defaultItem;
    } catch (e) {
      return null;
    }
  }

  void ChooseShippingMethod(ShippingMethodEntity shippingMethod) {
    _selectShipping = shippingMethod;
    notifyListeners();
  }

  void choosePaymentMethod(String paymentMethod) {
    _selectedPayment = paymentMethod;
    notifyListeners();
  }

  void chooseDeliveryTimeSlot(String timeSlot) {
    _selectedDeliveryTimeSlot = timeSlot;
    notifyListeners();
  }

  /// ----------------- Feature Order -------------------- //
  Future<void> getOrders() async {
    _isLoading = true;
    _isSuccess = false;
    try {
      _orders = await getOrderUsecase.call();
      _isSuccess = _orders.isNotEmpty;
      print(_orders[2].items);
    } catch (error) {
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get Quantity Item
  void getQuantityItem(String? order_id) {
    totalQuantityItem = 0;
    OrderEntity order = _orders.firstWhere((order) => order.id == order_id);
    List<OrderItemEntity> listOrderItems = order.items ?? [];

    for (OrderItemEntity orderItem in listOrderItems) {
      totalQuantityItem += orderItem?.quantity ?? 0;
    }
    notifyListeners();
  }

  String? _orderId;
  String? get orderId => _orderId;

  void setOrderId(String id) {
    _orderId = id;
    print("Gán Order ID ----------");
    notifyListeners();
  }

  /// - ----------- CREATE ORDER --------------------- ///
  Future<bool> createOrder(OrderEntity orderRequest) async {
    _isSuccess = false;
    _isLoading = true;
    notifyListeners();
    try {
      _orderId = await createOrderUsecase.call(orderRequest);
      if (_orderId != null) {
        _isSuccess = true;
      } else {
        _isSuccess = false;
      }
    } catch (error) {
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _isSuccess;
  }

  Future<OrderEntity?> getOrderByCode(String code) async {
    print("Đang ở provider");
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    try {
      print(code);
      _orderByCode = await getOrderByIdUseCase.call(code);
      print("Đã lấy order by code: ${_orderByCode?.id}");
      print("_orderByCode: ${_orderByCode!.items![0].order_line_id}");
      _isSuccess = _orderByCode != null;
    } catch (error) {
      _isSuccess = false;
      _orderByCode = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _orderByCode as OrderEntity;
  }
// ----------------------  FEATURE ADMIN --------------------- //

  Future<void> fetchAllOrder() async {
    try {
      _isLoading = true;
      notifyListeners();

      _orders = await fetchAllOrdersUsecase.fetchAllOrders();

      if (_orders.isNotEmpty) {
        _isSuccess = true;
        print(_orders.length);
        print('${_orders[0].shipping}');
      } else {
        _isSuccess = false;
      }
    } catch (error) {
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --------- Update order Status
  Future<bool> updateOrder(
      String orderID, Map<String, dynamic> updateData) async {
    try {
      _isLoading = true;
      notifyListeners();
      _isSuccess = await updateOrderUsecase.call(orderID, updateData);
    } catch (error) {
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
      return _isSuccess;
    }
  }

  void updateOrderLocally(String orderId, {required String newStatus}) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final oldStatus = _orders[index].orderStatus;
      _orders[index] = _orders[index].copyWith(orderStatus: newStatus);
      debugPrint('Order $orderId updated from $oldStatus to $newStatus');
      notifyListeners();
    } else {
      debugPrint('Order $orderId not found when trying to update status.');
    }
  }

  void updateOrderItemLocal(String orderId, String orderLineId) {
    print('Tìm order với id: $orderId');
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) {
      print('Không tìm thấy order với id: $orderId');
      return;
    }

    final order = _orders[orderIndex];
    final items = order.items ?? [];
    print('Số lượng item trong order: ${items.length}');

    final itemIndex =
        items.indexWhere((item) => item.order_line_id == orderLineId);
    if (itemIndex == -1) {
      print('Không tìm thấy order line với id: $orderLineId');
      return;
    }

    print('Đã tìm thấy item tại index $itemIndex. Cập nhật is_review = true');

    // Cập nhật item tại vị trí itemIndex
    final updatedItems = List<OrderItemEntity>.from(items);
    updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(is_review: true);

    // Cập nhật lại order với items đã cập nhật
    _orders[orderIndex] = order.copyWith(items: updatedItems);
    print('Đã cập nhật order tại index $orderIndex với item đã sửa đổi');

    notifyListeners();
    print('Đã gọi notifyListeners()');
  }

  // ------------------------- Lọc Order ------------------- //
// ------------------------- Enhanced Order Filtering ------------------- //

// Existing features
  List<OrderEntity> filteredUserOrders = [];

  List<OrderEntity> filterUserOrderByUserId(String userId) {
    return order.where((order) => order.userId == userId).toList();
  }

  List<OrderEntity> filterOrders = [];
  OrderEntity? filterOrderByOrderCode(String orderCode) {
    try {
      return order.firstWhere((order) => order.id == orderCode);
    } catch (e) {
      return null; // or throw if you want to report an error
    }
  }

  List<OrderEntity> filterOrdersByName(String nameCustomer) {
    return order
        .where((order) =>
            order.address.fullName
                ?.toLowerCase()
                .contains(nameCustomer.toLowerCase()) ??
            false)
        .toList();
  }

  List<OrderEntity> filterOrdersByDateRange(
      DateTime fromDate, DateTime toDate) {
    return order.where((order) {
      final orderDate = order.orderDate;
      if (orderDate == null) return false;

      return orderDate.isAfter(fromDate.subtract(const Duration(seconds: 1))) &&
          orderDate.isBefore(toDate.add(const Duration(seconds: 1)));
    }).toList();
  }

// ----------------------- New Filtering Features ----------------------- //

// Feature 5: Filter by price range
  List<OrderEntity> filterOrdersByPriceRange(double minPrice, double maxPrice) {
    return order.where((order) {
      final totalAmount = order.orderTotal;
      return totalAmount >= minPrice && totalAmount <= maxPrice;
    }).toList();
  }

// Feature 6: Filter by payment method
  List<OrderEntity> filterOrdersByPaymentMethod(String paymentMethod) {
    return order
        .where((order) =>
            order.paymentMethod.toLowerCase() == paymentMethod.toLowerCase())
        .toList();
  }

// Feature 8: Filter by product
  List<OrderEntity> filterOrdersByProduct(String productId) {
    return order.where((order) {
      return order.items!.any((product) => product.productId == productId);
    }).toList();
  }

// Feature 9: Filter by multiple statuses at once
  List<OrderEntity> filterOrdersByMultipleStatuses(List<String> statuses) {
    return order
        .where((order) => statuses.contains(order.orderStatus))
        .toList();
  }

// Feature 10: Filter by recent orders (last X days)
  List<OrderEntity> filterRecentOrders(int days) {
    final DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    return order.where((order) {
      final orderDate = order.orderDate;
      if (orderDate == null) return false;
      return orderDate.isAfter(cutoffDate);
    }).toList();
  }

// Tìm kiếm đơn hàng theo ID code
  OrderEntity? searchOrderById(String id) {
    OrderEntity searchedOrder;
    searchedOrder = _orders.firstWhere((item) => item.id == id);
    if (searchedOrder != null) {
      print("Đã tìm thấy order với mã code trên $id");
      return searchedOrder;
    } else {
      return null;
    }
  }

  String _searchKeyword = '';

  String get searchKeyword => _searchKeyword;
  List<OrderEntity> get orders => _orders;

  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    print("Bạn vừa nhập từ khóa order ID là ${keyword}");
    notifyListeners(); // Thông báo các tab cập nhật lại
  }

  // Hàm hỗ trợ lọc trực tiếp theo trạng thái + từ khoá
  List<OrderEntity> searchOrdersByStatus(String status) {
    return _orders.where((order) {
      final matchesStatus = order.orderStatus?.toLowerCase() == status.toLowerCase();
      final matchesSearch = _searchKeyword.isEmpty || order.id!.contains(_searchKeyword);
      return matchesStatus && matchesSearch;
    }).toList();
  }

// Feature 13: Combined Complex Filter
  List<OrderEntity> advancedFilter({
    String? userId,
    String? orderStatus,
    String? paymentMethod,
    double? minPrice,
    double? maxPrice,
    DateTime? fromDate,
    DateTime? toDate,
    String? customerName,
  }) {
    return order.where((order) {
      // Start with true and apply each filter condition
      bool match = true;

      if (userId != null) {
        match = match && order.userId == userId;
      }

      if (orderStatus != null) {
        match = match && order.orderStatus == orderStatus;
      }

      if (paymentMethod != null) {
        match = match && order.paymentMethod == paymentMethod;
      }

      if (minPrice != null) {
        match = match && order.orderTotal >= minPrice;
      }

      if (maxPrice != null) {
        match = match && order.orderTotal <= maxPrice;
      }

      if (fromDate != null && toDate != null && order.orderDate != null) {
        match = match &&
            order.orderDate!
                .isAfter(fromDate.subtract(const Duration(seconds: 1))) &&
            order.orderDate!.isBefore(toDate.add(const Duration(seconds: 1)));
      }

      if (customerName != null) {
        match = match &&
            (order.address.fullName
                    ?.toLowerCase()
                    .contains(customerName.toLowerCase()) ??
                false);
      }

      return match;
    }).toList();
  }

// Feature 14: Orders pending for more than X days (delayed orders)
  List<OrderEntity> filterDelayedOrders(int days) {
    final DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    return order.where((order) {
      return order.orderStatus == 'pending' &&
          order.orderDate != null &&
          order.orderDate!.isBefore(cutoffDate);
    }).toList();
  }

// Feature 15: Filter by shipping method
  List<OrderEntity> filterByShippingMethod(String shippingMethod) {
    return order
        .where((order) =>
            order.shipping?.toLowerCase() == shippingMethod.toLowerCase())
        .toList();
  }
  // Có thể cho màn hình có 1 trạng thái và màn hình cần nhiều trang thái 

  List<OrderEntity> getOrdersByStatus(dynamic statusOrList) {
  final List<String> statuses = statusOrList is String ? [statusOrList] : statusOrList;

  return _orders.where((order) {
    final matchesStatus = order.orderStatus != null &&
        statuses.contains(order.orderStatus!.toLowerCase());

    final matchesSearch = _searchKeyword.isEmpty ||
        order.id!.toLowerCase().contains(_searchKeyword.toLowerCase());

    return matchesStatus && matchesSearch;
  }).toList();
}

}
