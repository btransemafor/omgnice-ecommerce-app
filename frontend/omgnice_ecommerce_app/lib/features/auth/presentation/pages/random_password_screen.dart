import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class RandomPasswordScreen extends StatefulWidget {
  final String randomPassword;

  const RandomPasswordScreen({
    Key? key,
    required this.randomPassword,
  }) : super(key: key);

  @override
  State<RandomPasswordScreen> createState() => _RandomPasswordScreenState();
}

class _RandomPasswordScreenState extends State<RandomPasswordScreen>
    with TickerProviderStateMixin {
  bool _isCopied = false;
  bool _isPasswordVisible = false;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _copyPassword() {
    FlutterClipboard.copy(widget.randomPassword).then((_) {
      setState(() {
        _isCopied = true;
      });
      
      // Haptic feedback
      // HapticFeedback.lightImpact();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Password copied successfully!',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          elevation: 8,
        ),
      );
      
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isCopied = false;
          });
        }
      });
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
    _shakeController.forward().then((_) => _shakeController.reset());
  }

  void _navigateToHome() {
    context.pushNamed('congrats');
  }

  String get _displayPassword {
    if (_isPasswordVisible) {
      return widget.randomPassword;
    }
    return '•' * widget.randomPassword.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF064E3B), // Emerald 900
              Color(0xFF065F46), // Emerald 800
              Color(0xFF047857), // Emerald 700
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OMGNICE',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.3),

                const SizedBox(height: 30),
                // Description
                Text(
                  'Your account has been secured with a randomly generated password. For optimal security, we recommend updating it to something personal as soon as possible.',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFA7F3D0),
                    height: 1.6,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: -0.2),

                const Spacer(),

                // Password Card
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF065F46).withOpacity(0.8),
                                    const Color(0xFF047857).withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFF10B981).withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withOpacity(0.2),
                                    blurRadius: 32,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.eco,
                                          color: Color(0xFF10B981),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Generated Password',
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFF475569).withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SelectableText(
                                            _displayPassword,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF3B82F6),
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        IconButton(
                                          onPressed: _togglePasswordVisibility,
                                          icon: Icon(
                                            _isPasswordVisible 
                                                ? Icons.visibility_off 
                                                : Icons.visibility,
                                            color: const Color(0xFF64748B),
                                          ),
                                          splashRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          child: ElevatedButton.icon(
                                            onPressed: _copyPassword,
                                            icon: Icon(
                                              _isCopied ? Icons.check_circle : Icons.content_copy,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            label: Text(
                                              _isCopied ? 'Copied!' : 'Copy',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _isCopied 
                                                  ? const Color(0xFF10B981) 
                                                  : const Color(0xFF374151),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              elevation: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ).animate().scale(duration: 800.ms, delay: 800.ms).fadeIn(),

                const Spacer(),

             

                const SizedBox(height: 32),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _navigateToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 16, 81, 18)
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20, color: Color.fromARGB(255, 26, 85, 28),),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 1400.ms).slideY(begin: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}