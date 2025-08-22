import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_item_entity.dart';
import 'dart:math' as math;

class AnimatedNoteContainer extends StatefulWidget {
  final OrderItemEntity item;
  final Function(bool isExpanded)? onToggleExpand;
  const AnimatedNoteContainer({
    required this.item,
    super.key,
    this.onToggleExpand,
  });
  @override
  State<AnimatedNoteContainer> createState() => _AnimatedNoteContainerState();
}

class _AnimatedNoteContainerState extends State<AnimatedNoteContainer>
    with SingleTickerProviderStateMixin {
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late AnimationController _controller;
  bool _isExpanded = false;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotateAnimation =
        Tween<double>(begin: 0, end: math.pi / 180 * 360).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _noteController.text = widget.item!.note ?? "";
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          //margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A62B7).withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                        if (_isExpanded) {
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }

                        // Goi callback để thông báo cho widget cha biết
                        widget.onToggleExpand?.call(_isExpanded);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          RotationTransition(
                            turns: _rotateAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4A261).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.note_add,
                                color: Color(0xFFF4A261),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Notes',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          AnimatedRotation(
                            turns: _isExpanded ? 0.25 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: const Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isExpanded ? 120 : 0,
                    curve: Curves.easeInOut,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              style: GoogleFonts.poppins(fontSize: 12),
                              controller: _noteController,
                              readOnly: true, //  Không cho chỉnh sửa
                              maxLines: widget.item.note == '' ? 1 : 3,
                              decoration: InputDecoration(
                                hintText:
                                    widget.item.note == '' ? 'No Note' : '',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6A62B7),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
