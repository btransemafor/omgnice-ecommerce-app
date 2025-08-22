/* import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimationComplete = true;
        });
      }
    });

    // Tự động phát animation khi màn hình hiển thị
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            // Animation Lottie
            Transform.scale(
              scale: 1.6, // tăng gấp 1.5 lần (hoặc 2.0 tùy thích)
              child: Lottie.asset(
                'assets/lottie/order_success.json',
                controller: _controller,
                // height: 100,
                width: 250, // hoặc nhỏ lại width, vì scale sẽ phóng to lên
                fit: BoxFit.contain,
              ),
            ),

            //  const SizedBox(height: 20),

            // Tiêu đề
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isAnimationComplete ? 1.0 : 0.0,
              child: Text(
                'Order successful',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Thông báo
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isAnimationComplete ? 1.0 : 0.0,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Thank you for your order. Your order is being processed and will be delivered as soon as possible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Mã đơn hàng
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isAnimationComplete ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Order Code',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      Provider.of<OrderProvider>(context, listen: false).orderId ?? '#OMGNICE',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Nút tiếp tục mua sắm
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isAnimationComplete ? 1.0 : 0.0,
              child: ElevatedButton(
                onPressed: () {
                  context.goNamed('home'); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nút xem đơn hàng
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isAnimationComplete ? 1.0 : 0.0,
              child: TextButton(
                onPressed: () {
                  // TODO: Track Your Order
                  context.pushNamed('trackOrder'); 

                },
                child: const Text(
                  'Track Your Order',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimationComplete = true;
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FFF8),
              Color(0xFFE8F5E8),
              Colors.white,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.05),
                  
                  // Lottie Animation với shadow effect
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Transform.scale(
                      scale: 1.6,
                      child: Lottie.asset(
                        'assets/lottie/order_success.json',
                        controller: _controller,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Success Title với gradient text
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _isAnimationComplete ? 1.0 : 0.0,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                      ).createShader(bounds),
                      child: Text(
                        'Order Successful!',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle với icon
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _isAnimationComplete ? 1.0 : 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Payment confirmed',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Description
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    opacity: _isAnimationComplete ? 1.0 : 0.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Thank you for your purchase! Your order is being processed and will be delivered as soon as possible.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Order Code Card với modern design
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1200),
                    opacity: _isAnimationComplete ? 1.0 : 0.0,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.green.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'ORDER CODE',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.green.shade700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Provider.of<OrderProvider>(context, listen: false).orderId ?? '#OMGNICE001',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Copy to clipboard logic
                                          Clipboard.setData(ClipboardData(
                                                  text:  Provider.of<OrderProvider>(context, listen: false).orderId ?? ''));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Copied to clipboard: ${Provider.of<OrderProvider>(context, listen: false).orderId}'),
                                                  duration: const Duration(
                                                      seconds: 1),
                                              /*     behavior:
                                                      SnackBarBehavior.floating, */
                                                ),
                                              );
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    color: Colors.grey.shade600,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Action Buttons
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1400),
                    opacity: _isAnimationComplete ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        // Continue Shopping Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              context.goNamed('home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: Colors.green.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.white,),
                                const SizedBox(width: 8),
                                Text(
                                  'Continue Shopping',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Track Order Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: OutlinedButton(
                            onPressed: () {
                              context.pushNamed('trackOrder');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green.shade700,
                              side: BorderSide(
                                color: Colors.green.shade300,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.track_changes_outlined, size: 22, color: Colors.green,),
                                const SizedBox(width: 8),
                                Text(
                                  'Track Your Order',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}