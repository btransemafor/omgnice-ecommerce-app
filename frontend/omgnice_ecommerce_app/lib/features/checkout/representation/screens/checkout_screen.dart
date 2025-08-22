// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/constants.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/checkout/representation/widgets/card_add_note_order.dart';
import 'package:omgnice_ecommerce_app/features/checkout/representation/widgets/card_choose_voucher.dart';
import 'package:omgnice_ecommerce_app/features/checkout/representation/widgets/choose_delivery_time.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/card_choose_address.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/card_choose_payment.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/card_choose_shipping.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/order_item_list.dart';
import 'package:omgnice_ecommerce_app/features/payment/presentation/provider/payment_provider.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void handleOrder(BuildContext context) async {
    try {
      // Factor 1: Lấy địa chỉ để giao hàng
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final selectedAddress = addressProvider.defaultAddr;
      if (selectedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn địa chỉ giao hàng')),
        );
        return;
      }
      print("Selected address: ${selectedAddress.fullName}");

      // Factor 2: Phương thức vận chuyển
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final selectedShippingMethod = orderProvider.selectShipping;
      if (selectedShippingMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn phương thức vận chuyển')),
        );
        return;
      }
      print("Shipping method: ${selectedShippingMethod.name}");
      print("Phi van chuyen: ${selectedShippingMethod.discountPrice}");

      String? deliveryTimeSlot;
      if (selectedShippingMethod.name == 'Scheduled Delivery' ||
          selectedShippingMethod.name == 'Pickup') {
        deliveryTimeSlot = orderProvider.selectedDeliveryTimeSlot;
        if (deliveryTimeSlot == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng chọn thời gian giao hàng')),
          );
          return;
        }
        print("Delivery time slot: $deliveryTimeSlot");
      }

      // Factor 3: Phương thức thanh toán
      final selectedPayment = orderProvider.selectedPayment;
      if (selectedPayment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn phương thức thanh toán')),
        );
        return;
      }
      print("Selected payment method: $selectedPayment");

      // Factor 4: Danh sách sản phẩm
      final List<CartItemModel> selectedItems = cartProvider.cart;
      if (selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Giỏ hàng trống')),
        );
        return;
      }

      // In thông tin sản phẩm để debug
      for (var item in selectedItems) {
        print("Cart item: ${item.nameProduct}, Price: ${item.price}");
      }

      List<OrderItemEntity> items = selectedItems
          .map((item) => OrderItemEntity(
                variantId: item.variantId,
                productId: item.productId,
                note: item.note,
                quantity: item.quantity,
                price: (item.discountPrice ?? 0.0) as double,
              ))
          .toList();

      // Factor 5: Khuyến mãi
      final selectedPromotion = cartProvider.selectedPromotion;
      final discountAmount = cartProvider.promotionDiscount;
      print(
          "Selected promotion ID: ${selectedPromotion?.id}, Discount: $discountAmount");

      // Factor 6: Tổng giá trị đơn hàng
      double feeShipping = Provider.of<OrderProvider>(context, listen: false)
              .selectShipping
              ?.discountPrice ??
          0.0;
      final double orderTotalPrice = cartProvider.total + feeShipping;

      print('Order total price: $orderTotalPrice');

      // Factor 7: Ghi chú đơn hàng
      final orderNote = orderProvider.noteOrder;
      print("Order note: $orderNote");

      // Tạo OrderEntity
      final orderRequest = OrderEntity(
        paymentStatus: false,
        promotionId: selectedPromotion?.id,
        address: selectedAddress,
        shippingMethodId: selectedShippingMethod.id ?? '',
        paymentMethod: selectedPayment,
        orderTotal: orderTotalPrice,
        shippingFee: selectedShippingMethod.discountPrice ?? 0.0,
        discountAmount: discountAmount,
        notes: orderNote ?? '',
        items: items,
        delivery_time_slot: deliveryTimeSlot ?? '',
      );

      for (final i in items) {
        print('Price của sản phẩm ${i} :  ${i.price}');
      }

      print('Shipping method ID: ${orderRequest.shippingMethodId}');

      // Handle different payment methods
      if (selectedPayment == "Cash On Delivery") {
        bool success;
        success = await orderProvider.createOrder(orderRequest);
        if (success) {
          print("Xu Ly Dat Hang Order Thanh Cong ${orderProvider.orderId}");
          cartProvider.resetSelectPromotion();
          // Reset
          //   orderProvider

          context.goNamed('orderSuccess');
        } else {
          print("ĐON HÀNG XỬ LÝ KHÔNG THÀNH CÔNG");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đơn hàng xử lý không thành công')),
          );
        }
      } else if (selectedPayment == "PayOS") {
        print("Processing PayOS payment...");

        try {
          // Gọi hàm tạo đơn hàng từ PaymentProvider
          await Provider.of<PaymentProvider>(context, listen: false)
              .createPaymentLink(orderRequest);
          final payment =
              Provider.of<PaymentProvider>(context, listen: false).payment;

          if (payment?.checkoutUrl != null) {
            print("PayOS URL found: ${payment?.checkoutUrl}");
            print("PayOS orderCode: ${payment?.orderCode}");
            print("orderId: ${payment?.orderId}");

            // Lưu orderId cục bộ
            final String orderCode = payment!.orderCode ?? '';
            final String orderId = payment!.orderId ?? '';

            // Kiểm tra orderId trước khi gọi PayOSWebViewPage
            if (orderCode.isEmpty) {
              print("Error: orderId is null or empty");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Lỗi: Không tìm thấy mã đơn hàng')),
              );
              return;
            }

            // Log trước khi gọi PayOSWebViewPage
            print(
                "Preparing to navigate to PayOSWebViewPage with orderId: $orderCode");

            final result = await context.pushNamed(
              'payosWebview',
              extra: {
                'orderId': orderId,
                'orderCode': orderCode,
                'checkoutUrl': payment!.checkoutUrl,
                // 'returnUrl': 'http://192.168.124.242:8081/return.html',
              },
            );

            print("Result from PayOSWebViewPage: $result");

            if (result != null &&
                result is Map &&
                result['status'] == 'success') {
              context.goNamed('orderSuccess');
              cartProvider.resetSelectPromotion();
            } else if (result != null &&
                result is Map &&
                result['status'] == 'cancel') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bạn đã hủy thanh toán')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Không nhận được kết quả thanh toán')),
              );
            }
          } else {
            print("PayOS URL is null!");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Không thể tạo liên kết thanh toán')),
            );
          }
        } catch (paymentError) {
          print("Error processing PayOS payment: $paymentError");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi xử lý thanh toán: $paymentError')),
          );
        }
      } else if (selectedPayment == "MoMo E-wallet") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đang xử lý thanh toán qua MoMo...')),
        );
      } else {
        print("Unknown payment method: $selectedPayment");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Phương thức thanh toán không được hỗ trợ: $selectedPayment')),
        );
      }
    } catch (e, stacktrace) {
      print('Lỗi khi xử lý order: $e');
      print('Stacktrace: $stacktrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: BeautifulAppBar(
        title: 'Checkout order',
        titleColor: Colors.white,
        backButtonColor: Colors.white,
        gradient: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
              onPressed: () {
                // TODO: Return Home option
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  CardChooseAddress(),
                  const SizedBox(height: 5),
                  CardChooseShipping(),
                  Consumer<OrderProvider>(
                    builder: (context, shippingPro, child) {
                      final selectedShipping = shippingPro.selectShipping;

                      if (selectedShipping != null &&
                          (selectedShipping.name == 'Scheduled Delivery')) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ChooseDeliveryTimeWidget(
                            timeOptions: times,
                            onSelected: (selectedTime) {
                              print('Giờ giao đã chọn: $selectedTime');
                              shippingPro.chooseDeliveryTimeSlot(selectedTime);
                            },
                          ),
                        );
                      } else {
                        return const SizedBox(height: 10);
                      }
                    },
                  ),
                  CardChoosePayment(),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  OrderItemList(),
                  const SizedBox(height: 10),
                  CardChooseVoucher(),
                  const SizedBox(height: 5),
                  CardAddNoteOrder(),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Consumer<CartProvider>(
                                builder: (context, cartProv, child) {
                                  double subtotalPrice = cartProv.originalTotal;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      Text(
                                        FormatCurrency.formatCurrency(
                                            subtotalPrice),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Consumer<OrderProvider>(
                                    builder: (context, orderProv, child) {
                                      return Text(
                                        FormatCurrency.formatCurrency(orderProv
                                                .selectShipping
                                                ?.discountPrice ??
                                            0.0),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discount',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Consumer<CartProvider>(
                                    builder: (context, cartProv, child) {
                                      double discountValue =
                                          cartProv.promotionDiscount;
                                      return Text(
                                        '- ${FormatCurrency.formatCurrency(discountValue)}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Consumer<CartProvider>(
                                    builder: (context, cartProv, child) {
                                      double priceAfterVoucher = cartProv.total;
                                      double? feeShipping =
                                          Provider.of<OrderProvider>(context)
                                                  .selectShipping
                                                  ?.discountPrice ??
                                              0.0;
                                      double totalPrice =
                                          priceAfterVoucher + feeShipping;
                                      return Text(
                                        FormatCurrency.formatCurrency(
                                            totalPrice),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              final paymentMethod = Provider.of<OrderProvider>(
                                      context,
                                      listen: false)
                                  .selectedPayment;
                              print(
                                  "Payment button clicked. Selected method: $paymentMethod");
                              handleOrder(context);
                            },
                            child: Consumer<OrderProvider>(
                              builder: (context, orderProv, child) {
                                return Text(
                                  orderProv.selectedPayment ==
                                          'Cash On Delivery'
                                      ? 'Confirm order'
                                      : 'Proceed to payment',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
