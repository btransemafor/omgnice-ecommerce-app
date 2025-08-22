import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/model.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItemEntity orderItem; 
  const OrderItemTile({super.key, required this.orderItem}); 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // Image Product 
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network('${orderItem.thumbnail}'), 
          ), 
          // Columns 

          Column(
            children: [
              // Name Product 
              Text("${orderItem.productName}"), 
              // Rows: Size, Quantity, price 
              Row(children: [
                // Size 
                Row(
                  children: [
                    Text('Size ${orderItem.variantName}'),
                    Text('x${orderItem.quantity}'), 
                  ],
                ), 

                Text('${orderItem.price}') 
            
                // Quantity 
                // Price 
              ],)
            ],
          )

        ],
      )
    ); 
  }
}