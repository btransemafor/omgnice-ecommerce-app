import 'package:flutter/material.dart';
import 'dart:async';

class PromotionalCountdown extends StatefulWidget {
  final DateTime endTime;
  final String title;
  final String subtitle;
  final VoidCallback? onComplete;
  final Color primaryColor;
  final Color accentColor;
  final bool showMilliseconds;
  final CountdownStyle style;

  const PromotionalCountdown({
    Key? key,
    required this.endTime,
    this.title = "FLASH SALE",
    this.subtitle = "Kết thúc sau",
    this.onComplete,
    this.primaryColor = const Color(0xFFFF6B35),
    this.accentColor = const Color(0xFFFFD23F),
    this.showMilliseconds = false,
    this.style = CountdownStyle.card,
  }) : super(key: key);

  @override
  _PromotionalCountdownState createState() => _PromotionalCountdownState();
}

enum CountdownStyle { card, minimal, gradient, neon }

class _PromotionalCountdownState extends State<PromotionalCountdown>
    with TickerProviderStateMixin {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _pulseController.repeat(reverse: true);
    _bounceController.forward();
  }

  void _startTimer() {
    _updateTimeLeft();
    _timer = Timer.periodic(
      Duration(milliseconds: widget.showMilliseconds ? 100 : 1000),
      (timer) {
        _updateTimeLeft();
      },
    );
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    if (now.isBefore(widget.endTime)) {
      setState(() {
        _timeLeft = widget.endTime.difference(now);
      });
    } else {
      setState(() {
        _timeLeft = Duration.zero;
      });
      _timer?.cancel();
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case CountdownStyle.card:
        return _buildCardStyle();
      case CountdownStyle.minimal:
        return _buildMinimalStyle();
      case CountdownStyle.gradient:
        return _buildGradientStyle();
      case CountdownStyle.neon:
        return _buildNeonStyle();
    }
  }

  Widget _buildCardStyle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.primaryColor,
            widget.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildTimeDisplay(),
          const SizedBox(height: 12),
          _buildLabels(),
        ],
      ),
    );
  }

  Widget _buildMinimalStyle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            color: widget.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            widget.subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          _buildCompactTimeDisplay(),
        ],
      ),
    );
  }

  Widget _buildGradientStyle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.primaryColor,
            widget.accentColor,
            widget.primaryColor.withOpacity(0.8),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAnimatedHeader(),
          const SizedBox(height: 20),
          _buildGlowingTimeDisplay(),
          const SizedBox(height: 16),
          _buildLabels(),
        ],
      ),
    );
  }

  Widget _buildNeonStyle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNeonHeader(),
          const SizedBox(height: 20),
          _buildNeonTimeDisplay(),
          const SizedBox(height: 16),
          _buildNeonLabels(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.local_fire_department,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Icon(
          Icons.local_fire_department,
          color: Colors.white,
          size: 24,
        ),
      ],
    );
  }

  Widget _buildAnimatedHeader() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flash_on,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Icon(
                Icons.flash_on,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNeonHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: widget.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        widget.title,
        style: TextStyle(
          color: widget.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          shadows: [
            Shadow(
              color: widget.primaryColor.withOpacity(0.8),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeBox(_timeLeft.inDays.toString().padLeft(2, '0'), false),
        _buildTimeBox(_timeLeft.inHours.remainder(24).toString().padLeft(2, '0'), false),
        _buildTimeBox(_timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0'), false),
        _buildTimeBox(_timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0'), true),
      ],
    );
  }

  Widget _buildGlowingTimeDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildGlowingTimeBox(_timeLeft.inDays.toString().padLeft(2, '0')),
          _buildSeparator(),
          _buildGlowingTimeBox(_timeLeft.inHours.remainder(24).toString().padLeft(2, '0')),
          _buildSeparator(),
          _buildGlowingTimeBox(_timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0')),
          _buildSeparator(),
          _buildGlowingTimeBox(_timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0')),
        ],
      ),
    );
  }

  Widget _buildNeonTimeDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNeonTimeBox(_timeLeft.inDays.toString().padLeft(2, '0')),
        _buildNeonSeparator(),
        _buildNeonTimeBox(_timeLeft.inHours.remainder(24).toString().padLeft(2, '0')),
        _buildNeonSeparator(),
        _buildNeonTimeBox(_timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0')),
        _buildNeonSeparator(),
        _buildNeonTimeBox(_timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0')),
      ],
    );
  }

  Widget _buildCompactTimeDisplay() {
    return Text(
      "${_timeLeft.inDays.toString().padLeft(2, '0')}:"
      "${_timeLeft.inHours.remainder(24).toString().padLeft(2, '0')}:"
      "${_timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
      "${_timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0')}",
      style: TextStyle(
        color: widget.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildTimeBox(String time, bool animate) {
    final child = Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );

    if (animate) {
      return AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, _) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: child,
          );
        },
      );
    }
    return child;
  }

  Widget _buildGlowingTimeBox(String time) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          time,
          style: TextStyle(
            color: widget.primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildNeonTimeBox(String time) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.primaryColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Text(
          time,
          style: TextStyle(
            color: widget.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            shadows: [
              Shadow(
                color: widget.primaryColor.withOpacity(0.8),
                blurRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Text(
      ':',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNeonSeparator() {
    return Text(
      ':',
      style: TextStyle(
        color: widget.primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: widget.primaryColor.withOpacity(0.8),
            blurRadius: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLabel('NGÀY'),
        _buildLabel('GIỜ'),
        _buildLabel('PHÚT'),
        _buildLabel('GIÂY'),
      ],
    );
  }

  Widget _buildNeonLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNeonLabel('NGÀY'),
        _buildNeonLabel('GIỜ'),
        _buildNeonLabel('PHÚT'),
        _buildNeonLabel('GIÂY'),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return SizedBox(
      width: 50,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNeonLabel(String label) {
    return SizedBox(
      width: 50,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: widget.primaryColor.withOpacity(0.7),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// Example usage widget
class CountdownExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final endTime = DateTime.now().add(const Duration(days: 2, hours: 5, minutes: 30));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Countdown Examples'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Style
            PromotionalCountdown(
              endTime: endTime,
              title: "FLASH SALE",
              subtitle: "Kết thúc sau",
              style: CountdownStyle.card,
              primaryColor: const Color(0xFFFF6B35),
              onComplete: () => print("Sale ended!"),
            ),
            
            const SizedBox(height: 20),
            
            // Minimal Style
            Center(
              child: PromotionalCountdown(
                endTime: endTime,
                style: CountdownStyle.minimal,
                primaryColor: const Color(0xFF2E7D32),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Gradient Style
            PromotionalCountdown(
              endTime: endTime,
              title: "MEGA SALE",
              style: CountdownStyle.gradient,
              primaryColor: const Color(0xFF6A1B9A),
              accentColor: const Color(0xFFE91E63),
            ),
            
            const SizedBox(height: 20),
            
            // Neon Style
            PromotionalCountdown(
              endTime: endTime,
              title: "BLACK FRIDAY",
              style: CountdownStyle.neon,
              primaryColor: const Color(0xFF00E676),
            ),
          ],
        ),
      ),
    );
  }
}