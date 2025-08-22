import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_item_entity.dart';

class CardItem extends StatelessWidget {
  final OrderItemEntity item; 
  const CardItem({super.key, required this.item}); 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; 
  return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: 
          Row(
            children: [
              /// --- Hình ảnh sản phẩm ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.thumbnail ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 12),
          
              /// --- Tên + size + số lượng ---
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName ?? 'Name Product',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: size.height * 0.015)),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Size: ${item.variantName ?? '-'}",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
          
                            // Quantity
                            Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 13, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.pink[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'x${item.quantity}',
                                style: GoogleFonts.poppins(
                                    color: Colors.pink[500],
                                    fontSize: size.height * 0.012),
                              ),
                            ),
                          ],
                        ),
          
                        /// --- Giá ---
                        Text(
                          FormatCurrency.formatCurrency(item.price),
                          style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: size.height * 0.014),
                        ),
                      ],
                    ),
                
                  ],
                ),
              ),
            ],
          ),
      );
  }
}
