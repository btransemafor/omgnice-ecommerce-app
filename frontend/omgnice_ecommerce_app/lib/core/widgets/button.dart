import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatefulWidget {
  final String textButton;
  final bool oke; // ✅ phải là final!
  final VoidCallback? handleButton;

  const Button({
    super.key,
    required this.oke,
    required this.textButton,
    this.handleButton,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var styleFontButton = GoogleFonts.poppins(
      fontSize: size.width * 0.045,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            child: InkWell(
              onTap: widget.handleButton,
              borderRadius: BorderRadius.circular(25),
              splashColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.1),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: widget.oke
                      ? const LinearGradient(
                          colors: [Color(0xFF00C853), Color(0xFFFFA726)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: widget.oke ? null : Colors.green,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.15),
                      spreadRadius: _isPressed ? 1 : 2,
                      blurRadius: _isPressed ? 4 : 8,
                      offset: Offset(0, _isPressed ? 2 : 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    widget.textButton,
                    style: styleFontButton,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}