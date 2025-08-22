import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_view_model.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/widget/cart_item_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartItemScreen extends StatelessWidget {
  List<CartItemModel> cart;

  CartItemScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    //Provider.of<CartProvider>(context, listen: false).calculateTotal();
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildCartBody(context),
      bottomSheet: _buildBottomSheet(context),
    );
  }




  Widget _buildCartBody(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      // if (cartProvider.isDeleteSuccess) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     SuccessHelper.showSuccess(context, "Item removed successfully!");
      //     cartProvider.clearDeleteSuccessFlag();
      //   });
      // }

      // Tính toán padding bottom dựa trên kích thước màn hình
      final bottomPadding = MediaQuery.of(context).size.height * 0.3;

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(2, 8, 2, bottomPadding),
        itemCount: cartProvider.cart.length,
        itemBuilder: (context, index) {
          final itemCart =
              CartItemViewModel(cartItemModel: cartProvider.cart[index]);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CartItemCard(cartItem: itemCart),
          );
        },
      );
    });
  }

  Widget _buildBottomSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.285,
      padding: const EdgeInsets.fromLTRB(10, 16, 16, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPromotionSection(context),
          const SizedBox(height: 12),
          _buildOrderSummary(context),
          const SizedBox(height: 12),
          _buildCheckoutButton(context),
        ],
      ),
    );
  }

  Widget _buildPromotionSection(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartP, _) {
        final promo = cartP.selectedPromotion;
        return GestureDetector(
          onTap: () => context.pushNamed('mypromotion'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.green),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Icon(Icons.local_offer_outlined, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    promo?.code ?? "Apply Promo Code",
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    
                  ),
                ),
                promo != null
                    ? const Icon(Icons.check_circle,
                        size: 18, color: Colors.green)
                    : Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey.shade600),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartP, _) {
        final currency = FormatCurrency.formatCurrency;
        return Column(
          children: [
            _buildSummaryRow("Subtotal", currency(cartP.originalTotal.toInt())),
            const SizedBox(height: 6),
            _buildSummaryRow(
              "Discount",
              "- ${currency(cartP.promotionDiscount.toInt())}",
              valueColor: Colors.red,
            ),
            const Divider(height: 20),
            _buildSummaryRow(
              "Total",
              NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                  .format(cartP.total),
              isBold: true,
              valueColor: Colors.green.shade700,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: 
      ElevatedButton(
        onPressed: () => {

          // Check xem gigi
          // Set shipping mat dinh 
          //Provider.of<OrderProvider>(context, listen: false).setShippingInitial(), 
          context.pushNamed('checkout')
          
          },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          "Checkout",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
