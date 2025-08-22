
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class CardShippingMethod extends StatelessWidget {
  final ShippingMethodEntity shippingMethod;
  final bool isSelected;

  const CardShippingMethod({
    super.key,
    required this.shippingMethod,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      padding: const EdgeInsets.only(left: 16,right: 2, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: isSelected ? 3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (shippingMethod.name != null && shippingMethod.name!.isNotEmpty)
                            ? shippingMethod.name!
                            : 'Unnamed Method',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (shippingMethod.price != null &&
                            shippingMethod.discountPrice != null &&
                            shippingMethod.discountPrice! < shippingMethod.price!)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              FormatCurrency.formatCurrency(shippingMethod.price!),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7,), 
                        Text(
                          shippingMethod.price != null
                              ?  FormatCurrency.formatCurrency(shippingMethod.discountPrice!) 
                              : 'N/A',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  shippingMethod.description?.isNotEmpty == true
                      ? shippingMethod.description!
                      : 'No description available',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              return Radio<ShippingMethodEntity>(
                value: shippingMethod,
                groupValue: orderProvider.selectShipping,
                activeColor: Colors.green,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onChanged: (ShippingMethodEntity? value) {
                  if (value != null) {
                    orderProvider.ChooseShippingMethod(value);
                    print('⚡ CardShippingMethod: Selected ${value.name}');
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
