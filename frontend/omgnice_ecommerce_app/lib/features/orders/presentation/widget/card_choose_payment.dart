import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class CardChoosePayment extends StatelessWidget {
  const CardChoosePayment({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
     // margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(15),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choosing Payment Method",
              style: GoogleFonts.poppins(
                  fontSize: size.width * 0.036, fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.payment_outlined, color: Colors.green, size: 25),
                  const SizedBox(width: 10),

                  Consumer<OrderProvider>(builder:(context, orderPro, child) {
                    return    Text(orderPro?.selectedPayment ?? 'MoMo E-Wallet' ,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: size.width * 0.033,
                        color: Colors.grey.shade500,
                      )); 
                  })
               
                ],
              ),

              // Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: size.width * 0.25,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                     context.pushNamed('choosePayment'); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 174, 251, 177),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Change',
                      style: GoogleFonts.poppins(
                          color: Colors.green, fontSize: 9),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
