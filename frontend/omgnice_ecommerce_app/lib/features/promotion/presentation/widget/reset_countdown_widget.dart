import 'package:flutter/material.dart';
import 'dart:async';

import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/promotion_countdown.dart';

class DailyResetCountdown extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onComplete;
  final Color primaryColor;
  final Color accentColor;
  final CountdownStyle style;
  final Duration dailyDuration; // Thời gian countdown mỗi ngày
  final TimeOfDay resetTime; // Thời điểm reset mỗi ngày

  const DailyResetCountdown({
    Key? key,
    this.title = "FLASH SALE",
    this.subtitle = "Kết thúc sau",
    this.onComplete,
    this.primaryColor = const Color(0xFFFF6B35),
    this.accentColor = const Color(0xFFFFD23F),
    this.style = CountdownStyle.card,
    this.dailyDuration = const Duration(hours: 24), // Mặc định 24 giờ
    this.resetTime = const TimeOfDay(hour: 0, minute: 0), // Reset lúc 00:00
  }) : super(key: key);

  @override
  _DailyResetCountdownState createState() => _DailyResetCountdownState();
}

class _DailyResetCountdownState extends State<DailyResetCountdown>
    with TickerProviderStateMixin {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  DateTime? _currentEndTime;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _calculateNextEndTime();
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

  void _calculateNextEndTime() {
    final now = DateTime.now();
    
    // Tính thời điểm reset tiếp theo
    DateTime nextReset = DateTime(
      now.year,
      now.month,
      now.day,
      widget.resetTime.hour,
      widget.resetTime.minute,
    );
    
    // Nếu thời điểm reset hôm nay đã qua, chuyển sang ngày mai
    if (nextReset.isBefore(now)) {
      nextReset = nextReset.add(const Duration(days: 1));
    }
    
    // Tính thời gian kết thúc countdown (từ thời điểm reset trừ đi duration)
    _currentEndTime = nextReset.subtract(
      Duration(seconds: widget.dailyDuration.inSeconds - (nextReset.difference(now).inSeconds % widget.dailyDuration.inSeconds))
    );
    
    // Nếu thời gian kết thúc đã qua, reset sang chu kỳ mới
    if (_currentEndTime!.isBefore(now)) {
      _currentEndTime = nextReset;
    }
  }

  void _startTimer() {
    _updateTimeLeft();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _updateTimeLeft();
      },
    );
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    
    if (_currentEndTime != null && now.isBefore(_currentEndTime!)) {
      setState(() {
        _timeLeft = _currentEndTime!.difference(now);
      });
    } else {
      // Countdown kết thúc, reset cho chu kỳ mới
      _resetCountdown();
    }
  }

  void _resetCountdown() {
    setState(() {
      _timeLeft = Duration.zero;
    });
    
    // Gọi callback khi hoàn thành
    widget.onComplete?.call();
    
    // Tính toán thời gian kết thúc mới
    _calculateNextEndTime();
    
    // Restart animation
    _bounceController.reset();
    _bounceController.forward();
    
    // Cập nhật lại thời gian
    Future.delayed(const Duration(milliseconds: 100), () {
      _updateTimeLeft();
    });
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
          const SizedBox(height: 8),
          _buildResetInfo(),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
          const SizedBox(width: 4),
          _buildCompactResetInfo(),
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
          const SizedBox(height: 12),
          _buildResetInfo(),
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
          const SizedBox(height: 12),
          _buildNeonResetInfo(),
        ],
      ),
    );
  }

  Widget _buildResetInfo() {
    final nextReset = _getNextResetTime();
    return Text(
      'Reset lúc ${nextReset.hour.toString().padLeft(2, '0')}:${nextReset.minute.toString().padLeft(2, '0')} hàng ngày',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 11,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildCompactResetInfo() {
    final nextReset = _getNextResetTime();
    return Text(
      'Reset ${nextReset.hour.toString().padLeft(2, '0')}:${nextReset.minute.toString().padLeft(2, '0')}',
      style: TextStyle(
        color: Colors.grey[500],
        fontSize: 10,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildNeonResetInfo() {
    final nextReset = _getNextResetTime();
    return Text(
      'RESET ${nextReset.hour.toString().padLeft(2, '0')}:${nextReset.minute.toString().padLeft(2, '0')} DAILY',
      style: TextStyle(
        color: widget.primaryColor.withOpacity(0.6),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }

  DateTime _getNextResetTime() {
    final now = DateTime.now();
    DateTime nextReset = DateTime(
      now.year,
      now.month,
      now.day,
      widget.resetTime.hour,
      widget.resetTime.minute,
    );
    
    if (nextReset.isBefore(now)) {
      nextReset = nextReset.add(const Duration(days: 1));
    }
    
    return nextReset;
  }

  // Các method build khác giữ nguyên như code gốc...
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

// Example usage
class DailyCountdownExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Daily Reset Countdown'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Flash sale reset lúc 00:00 mỗi ngày, kéo dài 12 tiếng
            DailyResetCountdown(
              title: "FLASH SALE",
              subtitle: "Kết thúc sau",
              style: CountdownStyle.card,
              dailyDuration: const Duration(hours: 12),
              resetTime: const TimeOfDay(hour: 0, minute: 0),
              primaryColor: const Color(0xFFFF6B35),
              onComplete: () => print("Flash sale ended!"),
            ),
            
            const SizedBox(height: 20),
            
            // Happy hour reset lúc 17:00 mỗi ngày, kéo dài 3 tiếng
            DailyResetCountdown(
              title: "HAPPY HOUR",
              subtitle: "Kết thúc sau",
              style: CountdownStyle.gradient,
              dailyDuration: const Duration(hours: 3),
              resetTime: const TimeOfDay(hour: 17, minute: 0),
              primaryColor: const Color(0xFF6A1B9A),
              accentColor: const Color(0xFFE91E63),
              onComplete: () => print("Happy hour ended!"),
            ),
            
            const SizedBox(height: 20),
            
            // Midnight sale reset lúc 23:00, kéo dài 2 tiếng
            DailyResetCountdown(
              title: "MIDNIGHT DEAL",
              style: CountdownStyle.neon,
              dailyDuration: const Duration(hours: 2),
              resetTime: const TimeOfDay(hour: 23, minute: 0),
              primaryColor: const Color(0xFF00E676),
            ),
          ],
        ),
      ),
    );
  }
}