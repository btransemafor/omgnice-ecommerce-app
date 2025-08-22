import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';


class OrderCard extends StatelessWidget {
  final String orderId;
  final String dateTime;
  final String imageUrl;
  final String productName;
  final String productSize;
  final int quantity;
  final int price;
  final int totalItems;
  final int totalPrice;

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.dateTime,
    required this.imageUrl,
    required this.productName,
    required this.productSize,
    required this.quantity,
    required this.price,
    required this.totalItems,
    required this.totalPrice,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {


    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.receipt, color: Colors.grey.shade600, size: 20),
                  SizedBox(width: 5),
                  Text(
                    'Deliveried on $dateTime',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  orderId,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Product List
          Column(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),


                          const SizedBox(height: 5,),


                          Row(
                            children: [
                              Text(
                                'Size $productSize',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              const SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'x$quantity',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${FormatCurrency.formatCurrency(price)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),

          // Footer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalItems Item  |  ${FormatCurrency.formatCurrency(totalPrice)}',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.green,
                  fontWeight: FontWeight.w400,
                ),
              ),


                //height: 30,
                //height: 30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          backgroundColor: Colors.green.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(width: 1, color: Colors.green)
                        ),
                        child: Text(
                          'Review',
                          style: GoogleFonts.poppins(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                   // const SizedBox(width: 0,),


                    IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.green,), )
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
