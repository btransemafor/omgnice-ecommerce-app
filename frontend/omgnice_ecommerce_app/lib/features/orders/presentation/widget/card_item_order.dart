import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/animatedNote.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_model.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';

class CardItemOrder extends StatelessWidget {
  final CartItemModel? cartItem;

  const CardItemOrder({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedSize(
       duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
          //height: size.height * 0.22,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white),
          margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
          child: Column(
            children: [
              Row(children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 83,
                    height: 83,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(cartItem?.imageProduct ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
      
                // Product Information
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 6, vertical: size.height * 0.013),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          maxLines: 2,
                          cartItem!.nameProduct ?? '',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: size.width * 0.035,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Size: ${cartItem!.variantName}',
                              style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.03,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF82E62B),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: Text(
                                '${cartItem!.discountPrice} đ',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
      
                            // Quantity
                            Text(
                              'Qty: ${cartItem!.quantity}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ]),
              const SizedBox(
                height: 13,
              ),
              AnimatedNoteContainer(
                  item: OrderItemEntity(
                
                      note: cartItem?.note,
                      price: cartItem?.discountPrice as double))
            ],
          )),
    );
  }
}
