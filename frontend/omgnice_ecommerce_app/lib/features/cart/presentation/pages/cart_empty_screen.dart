import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/button.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/category_provider.dart';
import 'package:provider/provider.dart';
class CartEmptyScreen extends StatelessWidget {
  const CartEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; 
   // final cartItem = CartItemViewModel.cartItemhehe;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //const Text('Helolo'),
                  const SizedBox(height: 25,), 
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.asset(
                        'assets/cart.jpg', // Đảm bảo đường dẫn đúng
                        fit: BoxFit.contain,
                       // color: Colors.green,
                       // colorBlendMode: BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text("Your Cart is Empty", style: GoogleFonts.poppins(fontSize: size.width * 0.054, fontWeight:  FontWeight.w700) ),
                  const SizedBox(height: 16,),
                  Text('Looks like you haven’t added anything to your cart yet', style: GoogleFonts.poppins(fontSize: size.width * 0.038, color: Colors.grey, ), textAlign: TextAlign.center,),
                  const SizedBox(height: 40,),
                  Button(textButton: 'Discover', handleButton: (){
                    // Go to home
                    print('Go to Home Page');
                    context.goNamed('home'); 
                    Provider.of<ScreenManager>(context, listen: false ).goToHome();
                    Provider.of<CategoryProvider>(context, listen: false).selectCategory(0);
                  }, oke:false),
                  // Button

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
