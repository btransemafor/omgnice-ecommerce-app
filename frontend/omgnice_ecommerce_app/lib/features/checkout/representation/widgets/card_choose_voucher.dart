import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:provider/provider.dart';

class CardChooseVoucher extends StatelessWidget {
  const CardChooseVoucher({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
      padding: EdgeInsets.only(left: 20, bottom: 15, top: 15),
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
      child: Row(
        //  mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Icon
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.card_giftcard_outlined,
                      size: 20, color: Colors.green),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Voucher OMGNICE',
                    style: GoogleFonts.poppins(fontSize: size.width * 0.033),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            width: 40,
          ),

          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cartP, child) {
                return cartP.selectedPromotion != null
                    ? Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: ShapeDecoration(
                                color: Colors.transparent,
                                shape: TicketShapeBorder(
                                  side: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 245, 153, 14),
                                      width: 1.5),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '-${FormatCurrency.formatCurrency(cartP.promotionDiscount)}',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 233, 123, 13),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11),
                                ),
                              )),
                        ],
                      )
                    : TextButton(
                        onPressed: () async {
                          PromotionEntity? promotion =
                              await context.pushNamed('mypromotion');
                          if (promotion != null && context.mounted) {
                            print('Da chon promotion ${promotion.description}');
                            final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                              cartProvider.selectPromotion(promotion); 
                            cartProvider.applyPromotion(promotion);
                          }
                        },
                        child: Text(
                          'Choose vourcher',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 11),
                        ));
              },
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 20,
              color: Colors.grey,
            ),
            onPressed: () {
              context.pushNamed('mypromotion');
            },
          )

          // Icon Forward
        ],
      ),
    );
  }
}

class TicketShapeBorder extends ShapeBorder {
  final BorderSide side;

  const TicketShapeBorder({this.side = BorderSide.none});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) => TicketShapeBorder(side: side.scale(t));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const notchRadius = 4.0;
    final path = Path();

    // Bắt đầu từ góc trên bên trái
    path.moveTo(rect.left + notchRadius, rect.top);

    // Vẽ đường trên cùng
    path.lineTo(rect.right - notchRadius, rect.top);

    // Góc trên bên phải
    path.arcToPoint(
      Offset(rect.right, rect.top + notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: true,
    );

    // Vẽ cạnh bên phải
    path.lineTo(rect.right, rect.top + rect.height / 2 - notchRadius);

    // Vẽ phần khuyết bên phải
    path.arcToPoint(
      Offset(rect.right, rect.top + rect.height / 2 + notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    // Tiếp tục cạnh bên phải
    path.lineTo(rect.right, rect.bottom - notchRadius);

    // Góc dưới bên phải
    path.arcToPoint(
      Offset(rect.right - notchRadius, rect.bottom),
      radius: const Radius.circular(notchRadius),
      clockwise: true,
    );

    // Vẽ đường dưới cùng
    path.lineTo(rect.left + notchRadius, rect.bottom);

    // Góc dưới bên trái
    path.arcToPoint(
      Offset(rect.left, rect.bottom - notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: true,
    );

    // Vẽ cạnh bên trái
    path.lineTo(rect.left, rect.top + rect.height / 2 + notchRadius);

    // Vẽ phần khuyết bên trái
    path.arcToPoint(
      Offset(rect.left, rect.top + rect.height / 2 - notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    // Tiếp tục cạnh bên trái
    path.lineTo(rect.left, rect.top + notchRadius);

    // Góc trên bên trái
    path.arcToPoint(
      Offset(rect.left + notchRadius, rect.top),
      radius: const Radius.circular(notchRadius),
      clockwise: true,
    );

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = side.toPaint();
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }
}
