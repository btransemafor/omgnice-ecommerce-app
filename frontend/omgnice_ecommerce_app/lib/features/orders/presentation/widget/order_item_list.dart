// ----------- Này dùng trong checkout nè ------------------ //// 

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/card_item_order.dart';
import 'package:provider/provider.dart';


class OrderItemList extends StatelessWidget {
  const OrderItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 202, 197, 197),
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
      ),
      margin: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
      padding: EdgeInsets.only(left: 12, right: 12, top : 30, bottom: 0 ),
      //color: Colors.white, //  toàn vùng OrderItemList có nền trắng
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Items List",
                style: GoogleFonts.poppins(
                    fontSize: size.width * 0.036, fontWeight: FontWeight.w700, color: const Color.fromARGB(255, 5, 5, 5)),
              ),

              // Icon(Icons.arrow_forward_ios, color: Colors.grey.shade500, size: 20),

              Text('${context.watch<CartProvider>().cart.length} items',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.035,
                    color: Colors.grey.shade500,
                  )),     
            ],
          ),
          // const SizedBox(height: 10),
          // Divider(thickness: 1, color: Colors.grey[300]),
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final cart = cartProvider.cart;
/*
              if (cart.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Giỏ hàng đang trống",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }

*/
              return ListView.builder(
                itemCount: cart.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final itemView = cart[index];
                  return CardItemOrder(cartItem: itemView);
                },
              );
            },
          ),
          const SizedBox(height: 5,)
        ],
      ),
    );
  }
}
