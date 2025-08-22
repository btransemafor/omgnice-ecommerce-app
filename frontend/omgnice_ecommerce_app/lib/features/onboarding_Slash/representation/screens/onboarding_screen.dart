import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _handleGetStarted();
    }
  }

  void _handleGetStarted() {
    // Add navigation logic here
    print("Navigate to main app");
     context.goNamed('login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < 4)
                    TextButton(
                      onPressed: () => _handleGetStarted(),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
                children: [
                  _buildSlide1(),
                  _buildSlide2(),
                  _buildSlide3(),
                  _buildSlide4(),
                  _buildSlide5(),
                ],
              ),
            ),
            // Bottom section with dots and button
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Color(0xFF4CAF50) // Màu xanh lá chủ đạo
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50), // Màu xanh lá
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 4,
                        shadowColor: Color(0xFF4CAF50).withOpacity(0.3),
                      ),
                      child: Text(
                        _currentPage == 4 ? 'Get Started!' : 'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide1() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and main image
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4CAF50).withOpacity(0.1), // Xanh lá nhạt
                    Color(0xFF8BC34A).withOpacity(0.1), // Xanh lá sáng
                  ],
                ),
                borderRadius: BorderRadius.circular(140),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background pattern
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  // Drink glass icon
                  Icon(
                    Icons.local_drink,
                    size: 100,
                    color: Color(0xFF4CAF50), // Xanh lá
                  ),
                  // Water drops
                  Positioned(
                    top: 60,
                    right: 80,
                    child: Icon(
                      Icons.water_drop,
                      size: 20,
                      color: Color(0xFF8BC34A), // Xanh lá sáng
                    ),
                  ),
                  Positioned(
                    bottom: 70,
                    left: 90,
                    child: Icon(
                      Icons.water_drop,
                      size: 16,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Welcome to\nFresh Drink!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                height: 1.3,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Fresh, refreshing drinks delivered\nto you in minutes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide2() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center ,
                children: [
                  // Background circle
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4CAF50).withOpacity(0.1),
                          Color(0xFF8BC34A).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(125),
                    ),
                  ),
                  // Fruits arrangement
                  Positioned(
                    top: 40,
                    child: Icon(Icons.apple, size: 40, color: Color(0xFFFF5722)),
                  ),
                  Positioned(
                    left: 40,
                    top: 100,
                    child: Icon(Icons.local_florist, size: 35, color: Color(0xFF4CAF50)),
                  ),
                  Positioned(
                    right: 40,
                    top: 100,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Color(0xFF8BC34A),
                        borderRadius: BorderRadius.circular(17.5),
                      ),
                    ),
                  ),
                  // Center leaf icon
                  Icon(
                    Icons.eco,
                    size: 80,
                    color: Color(0xFF4CAF50),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 60,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 60,
                    child: Icon(Icons.grass, size: 30, color: Color(0xFF8BC34A)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text(
              '100% Natural\nIngredients',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                height: 1.3,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We use only fresh fruits and\nclean ingredients for delicious\ntaste and your health',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide3() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4CAF50).withOpacity(0.1),
                          Color(0xFF8BC34A).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(125),
                    ),
                  ),
                  // Delivery truck
                  Icon(
                    Icons.local_shipping,
                    size: 100,
                    color: Color(0xFF4CAF50),
                  ),
                  // Speed lines
                  Positioned(
                    left: 30,
                    child: Column(
                      children: [
                        Container(width: 20, height: 3, color: Color(0xFF8BC34A)),
                        SizedBox(height: 5),
                        Container(width: 15, height: 3, color: Color(0xFF8BC34A)),
                        SizedBox(height: 5),
                        Container(width: 25, height: 3, color: Color(0xFF8BC34A)),
                      ],
                    ),
                  ),
                  // Clock
                  Positioned(
                    top: 50,
                    right: 50,
                    child: Icon(
                      Icons.access_time,
                      size: 30,
                      color: Color(0xFF8BC34A),
                    ),
                  ),
                  // Location pin
                  Positioned(
                    bottom: 50,
                    right: 60,
                    child: Icon(
                      Icons.location_on,
                      size: 25,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Fast\nDelivery',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                height: 1.3,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Order now, get your chilled drink\ndelivered in 30 minutes\nno long waits',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide4() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4CAF50).withOpacity(0.1),
                          Color(0xFF8BC34A).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(125),
                    ),
                  ),
                  // Main discount icon
                  Icon(
                    Icons.local_offer,
                    size: 100,
                    color: Color(0xFF4CAF50),
                  ),
                  // Percentage
                  Positioned(
                    top: 60,
                    left: 60,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF8BC34A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '30%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Money save icon
                  Positioned(
                    bottom: 70,
                    left: 50,
                    child: Icon(
                      Icons.savings,
                      size: 35,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  // Gift icon
                  Positioned(
                    top: 80,
                    right: 50,
                    child: Icon(
                      Icons.card_giftcard,
                      size: 30,
                      color: Color(0xFF8BC34A),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Daily\nDeals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                height: 1.3,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Special promotions and combo deals\nlet you enjoy drinks without\nworrying about the price',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide5() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background celebration
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4CAF50).withOpacity(0.1),
                          Color(0xFF8BC34A).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(125),
                    ),
                  ),
                  // Happy person with drink
                  Icon(
                    Icons.celebration,
                    size: 100,
                    color: Color(0xFF4CAF50),
                  ),
                  // Drink icons around
                  Positioned(
                    top: 50,
                    left: 50,
                    child: Icon(
                      Icons.local_drink,
                      size: 25,
                      color: Color(0xFF8BC34A),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 50,
                    child: Icon(
                      Icons.emoji_emotions,
                      size: 30,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 60,
                    child: Icon(
                      Icons.favorite,
                      size: 25,
                      color: Color(0xFF8BC34A),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 60,
                    child: Icon(
                      Icons.star,
                      size: 25,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Ready to\nEnjoy?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                height: 1.3,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sign in or register to explore\nthe world of delicious drinks\ntoday!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}