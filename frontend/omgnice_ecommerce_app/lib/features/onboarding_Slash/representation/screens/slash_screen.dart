import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _bubbleController;
  late AnimationController _waveController;
  late AnimationController _logoController;
  late AnimationController _dropController;
  late AnimationController _gradientController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _dropAnimation;
  late Animation<Color?> _gradientAnimation;

  List<Bubble> bubbles = [];
  List<WaterDrop> waterDrops = [];
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateBubbles();
    _generateWaterDrops();
    _startAnimationSequence();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _logoAlignment = Alignment(0, -0.1);
      });
    });
  }

  Alignment _logoAlignment = Alignment.center;

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _dropController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _gradientController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.0, curve: Curves.easeIn),
      ),
    );

    _logoRotation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _bubbleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_bubbleController);
    _waveAnimation =
        Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_waveController);
    _dropAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_dropController);

    _gradientAnimation = ColorTween(
      begin: const Color(0xFF4CAF50), // Green
      end: const Color(0xFF8BC34A), // Light Green
    ).animate(_gradientController);
  }

  void _generateBubbles() {
    final random = math.Random();
    for (int i = 0; i < 15; i++) {
      bubbles.add(Bubble(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 20 + 10,
        speed: random.nextDouble() * 0.02 + 0.01,
        delay: random.nextDouble() * 2000,
      ));
    }
  }

  void _generateWaterDrops() {
    final random = math.Random();
    for (int i = 0; i < 8; i++) {
      waterDrops.add(WaterDrop(
        x: random.nextDouble() * 0.6 + 0.2,
        startY: -0.1,
        endY: 0.4,
        size: random.nextDouble() * 15 + 8,
        delay: i * 200.0,
        duration: random.nextDouble() * 1000 + 1500,
      ));
    }
  }

  Future<void> _startAnimationSequence() async {
    print('Starting animation sequence');
    _gradientController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    print('Starting drop animation');
    _dropController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    print('Starting logo animation');
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 3000));
    print('Checking first launch and navigating');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunchAndNavigate();
    });
  }

  Future<void> _checkFirstLaunchAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      //
      print('Is first launch: $isFirstLaunch');
      isFirstLaunch = true;
      if (isFirstLaunch) {
        context.goNamed('onboarding');
        await prefs.setBool('isFirstLaunch', false);
      } else {
        // Không phải lần đầu, điều hướng  LoginScreen
        context.goNamed('login');
      }
    } catch (e, stackTrace) {
      print('Navigation error: $e');
      print('Stack trace: $stackTrace');
      // Fallback navigation
      //  context.goNamed('login');
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bubbleController.dispose();
    _waveController.dispose();
    _logoController.dispose();
    _dropController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _bubbleController,
          _waveController,
          _logoController,
          _dropController,
          _gradientController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _gradientAnimation.value ?? const Color(0xFF4CAF50),
                  const Color(0xFF4CAF50),
                  const Color(0xFF8BC34A),
                  _gradientAnimation.value?.withOpacity(0.8) ??
                      const Color(0xFF8BC34A),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: Stack(
              children: [
                _buildWaveBackground(),
                _buildBubbles(),
                _buildWaterDrops(),
                _buildLogo(),
                _buildBrandName(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaveBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: WavePainter(_waveAnimation.value),
      ),
    );
  }

  Widget _buildBubbles() {
    return Positioned.fill(
      child: CustomPaint(
        painter: BubblePainter(bubbles, _bubbleAnimation.value),
      ),
    );
  }

  Widget _buildWaterDrops() {
    return Positioned.fill(
      child: CustomPaint(
        painter: WaterDropPainter(waterDrops, _dropAnimation.value),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedAlign(
      duration: Duration(milliseconds: 500),
      alignment: _logoAlignment, // biến Alignment bạn định nghĩa trong State
      child: Transform.scale(
        scale: _logoScale.value,
        child: Transform.rotate(
          angle: _logoRotation.value,
          child: Opacity(
            opacity: _logoOpacity.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_drink,
                    size: 120,
                    color: Color(0xFF4CAF50), // Green
                  ),
                ),
                if (_shimmerAnimation.value > -1.0 &&
                    _shimmerAnimation.value < 2.0)
                  ClipOval(
                    child: Container(
                      width: 120,
                      height: 120,
                      child: CustomPaint(
                        painter: ShimmerPainter(_shimmerAnimation.value),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandName() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.3,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: _logoOpacity.value,
        child: const Column(
          children: [
            Text(
              'OMGNICE',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fresh drinks every day',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white70,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    const waveHeight = 30.0;
    final waveLength = size.width / 2;

    path.moveTo(0, size.height * 0.8);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.8 +
          waveHeight *
              math.sin((x / waveLength + animationValue) * 2 * math.pi);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    paint.color = Colors.white.withOpacity(0.05);
    final path2 = Path();
    path2.moveTo(0, size.height * 0.85);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.85 +
          waveHeight *
              0.7 *
              math.sin((x / waveLength - animationValue) * 2 * math.pi);
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double animationValue;

  BubblePainter(this.bubbles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (final bubble in bubbles) {
      final progress = (animationValue * 2000 + bubble.delay) % 2000 / 2000;
      final y = size.height * (bubble.y + progress * bubble.speed);

      if (y < size.height) {
        final opacity = (1.0 - progress) * 0.4;
        paint.color = Colors.white.withOpacity(opacity);

        canvas.drawCircle(
          Offset(size.width * bubble.x, y),
          bubble.size * (0.5 + progress * 0.5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WaterDropPainter extends CustomPainter {
  final List<WaterDrop> drops;
  final double animationValue;

  WaterDropPainter(this.drops, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (final drop in drops) {
      final progress =
          math.max(0.0, (animationValue * 2000 - drop.delay) / drop.duration);

      if (progress > 0 && progress <= 1) {
        final y =
            size.height * (drop.startY + (drop.endY - drop.startY) * progress);
        final opacity = progress < 0.8 ? 0.6 : (1.0 - progress) * 3;

        paint.color = Colors.white.withOpacity(opacity);

        final path = Path();
        final centerX = size.width * drop.x;
        final radius = drop.size;

        path.addOval(
            Rect.fromCircle(center: Offset(centerX, y), radius: radius));
        path.moveTo(centerX, y - radius);
        path.quadraticBezierTo(
            centerX - radius * 0.5, y - radius * 1.5, centerX, y - radius * 2);
        path.quadraticBezierTo(
            centerX + radius * 0.5, y - radius * 1.5, centerX, y - radius);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShimmerPainter extends CustomPainter {
  final double progress;

  ShimmerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(
        size.width * (progress - 0.3),
        0,
        size.width * 0.6,
        size.height,
      ));

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * (progress - 0.3),
        0,
        size.width * 0.6,
        size.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Bubble {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

class WaterDrop {
  final double x;
  final double startY;
  final double endY;
  final double size;
  final double delay;
  final double duration;

  WaterDrop({
    required this.x,
    required this.startY,
    required this.endY,
    required this.size,
    required this.delay,
    required this.duration,
  });
}
