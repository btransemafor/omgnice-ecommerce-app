import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/static_word.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import '../provider/cart_provider.dart';
import 'cart_empty_screen.dart';
import 'cart_item_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the calculation for after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).calculateTotal();
      context.read<CartProvider>().initCart();
   
    });

     Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).getShipping(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  BeautifulAppBar(
        title: 'My Cart',
        titleColor: Colors.white,
        backButtonColor : Colors.white,
        gradient: true,
        cartAppbar: true,
        actions: [
          _helpIconAction(context)
        ],
      ),
      body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
        if (cartProvider.cart.isNotEmpty) {
          return CartItemScreen(cart: cartProvider.cart);
        }
        return CartEmptyScreen();
      }),
    );
  }
}

Widget _helpIconAction(context) {
  return  Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white, size: 25,),
              onPressed: () {
                _showHelpDialog(context); 
              },
            ),
          ); 
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    toolbarHeight: 65,
    backgroundColor: Colors.white,
    leading: Container(
      padding: EdgeInsets.only(left: 6),
      margin: EdgeInsets.only(top: 13, bottom: 13, left: 10, right: 7),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40)),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
          onPressed: () {
            if (ModalRoute.of(context)?.settings.name ==
                '/ProductDetailScreen') {
              Navigator.pop(context);
            } else {
              Provider.of<ScreenManager>(context, listen: false)
                  .onItemSelected(0, context);
            }
          },
        ),
      ),
    ),
    centerTitle: true,
    title: Text(
      "My Cart",
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    actions: [],
  );
}

void _showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: Text(
        'Help Guide',
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        StaticWords.helpText,
        style: GoogleFonts.poppins(
          color: Colors.grey[800],
          fontSize: 14,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
