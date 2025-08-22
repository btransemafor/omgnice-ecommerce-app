import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:go_router/go_router.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/home_provider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:provider/provider.dart';

class EcommerceLuckyWheel extends StatefulWidget {
  const EcommerceLuckyWheel({super.key});

  @override
  State<EcommerceLuckyWheel> createState() => _EcommerceLuckyWheelState();
}

class _EcommerceLuckyWheelState extends State<EcommerceLuckyWheel>
    with TickerProviderStateMixin {
  final StreamController<int> _controller = StreamController<int>();
  String _selectedItem = '';
  bool _isSpinning = false;
  int? _lastSelectedIndex;

  late AnimationController _pulseController;
  late AnimationController _particleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _ecommerceRewards = [
    {
      'text': 'Free Drink\nTicket(1x), Max 250K',
      'icon': '🧃',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'text': 'Better Luck\nNext Time',
      'icon': '🍀',
      'gradient': const LinearGradient(
        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'text': '+50\nPoints',
      'icon': '⭐',
      'gradient': const LinearGradient(
        colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'text': '50% OFF\nVoucher',
      'icon': '🎟️',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFFECD2), Color(0xFFFCB69F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'text': '100K OFF\nVouchers',
      'icon': '💰',
      'gradient': const LinearGradient(
        colors: [Color(0xFFA8EDEA), Color(0xFFFED6E3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
    

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.elasticOut),
    );
    
  }

  @override
  void dispose() {
    _controller.close();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _spinWheel() async {
    if (_isSpinning) return;

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    final canSpin = await homeProvider.canSpin();

    if (!canSpin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have no spins left for today.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSpinning = true;
      _selectedItem = '';
    });

    final randomIndex = Random().nextInt(_ecommerceRewards.length);
    _lastSelectedIndex = randomIndex;
    _controller.add(randomIndex);

    _particleController.forward().then((_) {
      _particleController.reset();
    });
  }

  // New function to handle rewards using switch case
  void _handleReward(int index) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final rewardText = _ecommerceRewards[index]['text'];
    final promotionProvider =
        Provider.of<PromotionProvider>(context, listen: false);

    // Call saveUserPromotion asynchronously and wait for the result

    switch (index) {
      case 0: // Free Drink Ticket (1x)
        // Logic for awarding a free drink ticket
        //   Provider.of<PromotionProvider>(context, listen: false)
        //    .saveUserPromotion(12);
        bool result = await promotionProvider.saveUserPromotion(29, true);
        if (result) {
          print(promotionProvider.isSuccess);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You won a Free Drink Ticket!'),
            backgroundColor: Colors.green,
          ),
        );
        // Example: Update HomeProvider with the reward
        // homeProvider.addDrinkTicket(1);
        break;

      case 1: // Better Luck Next Time
        // Logic for no reward
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Better Luck Next Time!'),
            backgroundColor: Colors.blueGrey,
          ),
        );
        break;

/*       case 2: // One More Spin
        // Logic to grant an extra spin
        // homeProvider.grantExtraSpin(); // Assuming HomeProvider has this method
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You won an extra spin!'),
            backgroundColor: Colors.green,
          ),
        );
        break;
 */
      case 2: // +50 Points
        // Logic for adding points
        //  updateProfile
        Provider.of<UserProvider>(context, listen: false).updatePoint(50);
        //  homeProvider.addPoints(50); // Assuming HomeProvider has this method
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You earned 50 points!'),
            backgroundColor: Colors.green,
          ),
        );
        break;

      case 3:
/*         Provider.of<PromotionProvider>(context, listen: false)
            .saveUserPromotion(25); */
        bool result = await promotionProvider.saveUserPromotion(28, true);
        if (result) {
          print(promotionProvider.isSuccess);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You won a 50% OFF Voucher!'),
            backgroundColor: Colors.green,
          ),
        );
        break;

      case 4: 

        bool result = await promotionProvider.saveUserPromotion(27, true);
        if (result) {
          print(promotionProvider.isSuccess);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You won 1x 100K OFF Vouchers!'),
            backgroundColor: Colors.green,
          ),
        );
        break;

      default:
        // Fallback case
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong!'),
            backgroundColor: Colors.redAccent,
          ),
        );
    }
  }

  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlePainter(_particleController.value),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFF6B73FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              final wheelSize = (screenWidth * 0.8).clamp(200.0, 400.0);
              final resultBoxHeight = (screenHeight * 0.15).clamp(80.0, 120.0);

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight),
                  child: Stack(
                    children: [
                      _buildFloatingParticles(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Header
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          right: screenWidth * 0.04,
                                          left: screenWidth * 0.04,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.yellow.withOpacity(0.8),
                                              Colors.orange.withOpacity(0.8),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.yellow
                                                  .withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: screenWidth * 0.02),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'WHEEL OF LUCK',
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 8.0,
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      offset:
                                                          const Offset(2, 2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.05),
                                      Text(
                                        'OMGNICE Golden Opportunity',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.03),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Fortune Wheel
                          Container(
                            height: wheelSize,
                            width: wheelSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.2),
                                  blurRadius: 30,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: FortuneWheel(
                              selected: _controller.stream,
                              onAnimationEnd: () {
                                setState(() {
                                  _isSpinning = false;
                                  _selectedItem =
                                      _ecommerceRewards[_lastSelectedIndex ?? 0]
                                          ['text'];
                                });
                                // Call the reward handler
                                _handleReward(_lastSelectedIndex ?? 0);
                              },
                              animateFirst: false,
                              duration: const Duration(seconds: 4),
                              items: _ecommerceRewards.map((reward) {
                                return FortuneItem(
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(screenWidth * 0.015),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          reward['icon'],
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.05),
                                        ),
                                        SizedBox(height: screenHeight * 0.005),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            reward['text'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.025,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: const [
                                                Shadow(
                                                  blurRadius: 2.0,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  style: FortuneItemStyle(
                                    color: Colors.transparent,
                                    borderColor: Colors.white.withOpacity(0.3),
                                    borderWidth: 2,
                                  ),
                                );
                              }).toList(),
                              indicators: [
                                FortuneIndicator(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Colors.yellow, Colors.orange],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.yellow.withOpacity(0.5),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      size: screenWidth * 0.1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Result Box
                          Padding(
                            padding: EdgeInsets.only(
                                right: screenWidth * 0.09,
                                top: screenHeight * 0.05,
                                left: screenHeight * 0.05),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.elasticOut,
                              height: resultBoxHeight,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.015,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _selectedItem.isEmpty
                                      ? [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.05)
                                        ]
                                      : [
                                          Colors.yellow.withOpacity(0.8),
                                          Colors.orange.withOpacity(0.8)
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: _selectedItem.isEmpty
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.yellow.withOpacity(0.4),
                                          blurRadius: 15,
                                          spreadRadius: 3,
                                        ),
                                      ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      _selectedItem.isEmpty
                                          ? Icons.casino
                                          : Icons.celebration,
                                      key: ValueKey(_selectedItem.isEmpty),
                                      color: _selectedItem.isEmpty
                                          ? Colors.white70
                                          : Colors.white,
                                      size: screenWidth * 0.07,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        _selectedItem.isEmpty
                                            ? 'Spin to Win!'
                                            : 'Congratulations! You won:\n$_selectedItem',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedItem.isEmpty
                                              ? Colors.white70
                                              : Colors.white,
                                          shadows: const [
                                            Shadow(
                                              blurRadius: 4.0,
                                              color: Colors.black26,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Spin Button
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.08),
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale:
                                      _isSpinning ? 1.0 : _pulseAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF667EEA),
                                          Color(0xFF764BA2)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF667EEA)
                                              .withOpacity(0.4),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed:
                                          _isSpinning ? null : _spinWheel,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.1,
                                          vertical: screenHeight * 0.02,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: _isSpinning
                                                ? SizedBox(
                                                    width: screenWidth * 0.04,
                                                    height: screenWidth * 0.04,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.refresh,
                                                    color: Colors.white,
                                                    size: screenWidth * 0.05,
                                                  ),
                                          ),
                                          SizedBox(width: screenWidth * 0.02),
                                          Text(
                                            _isSpinning
                                                ? 'Spinning...'
                                                : 'SPIN NOW!',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Return Home Button
                          ElevatedButton(
                            onPressed: () {
                              // context.Named('home');
                              final notificationPro = Provider.of<NotificationProvider>(context, listen: false);
                              notificationPro.fetchNotifications(); 
                              context.pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.08,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 10, 23, 79),
                                    Color(0xFF764BA2)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF667EEA)
                                        .withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.15,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Text(
                                    "Return Home",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final random = Random(42);

    for (int i = 0; i < 15; i++) {
      final x = size.width * random.nextDouble();
      final y = size.height * (random.nextDouble() + animationValue) % 1;
      final radius = 2.0 + random.nextDouble() * 3.0;

      canvas.drawCircle(
        Offset(x, y * size.height),
        radius * (0.5 + 0.5 * sin(animationValue * 2 * pi + i)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
