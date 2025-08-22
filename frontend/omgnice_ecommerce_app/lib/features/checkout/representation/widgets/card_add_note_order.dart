import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class CardAddNoteOrder extends StatefulWidget {
  CardAddNoteOrder({super.key});

  @override
  State<CardAddNoteOrder> createState() => _CardAddNoteOrderState();
}

class _CardAddNoteOrderState extends State<CardAddNoteOrder> {
  bool is_expand = true;
  TextEditingController _noteForOrder = TextEditingController();
  FocusNode _focusNodeNoteOrder = FocusNode();

  @override
  void dispose() {
    _noteForOrder.dispose();
    _focusNodeNoteOrder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 202, 197, 197),
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                is_expand = !is_expand;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  color: Colors.green,
                ),
                Text(
                  "Add Note For Order",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.036,
                    color: Colors.black87,
                  ),
                ),
                AnimatedRotation(
                  turns: is_expand ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.expand_more_rounded,
                    size: 28,
                    color: Colors.green.shade400,
                  ),
                )
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: is_expand ? 150 : 0,
            padding:
                is_expand ? const EdgeInsets.only(top: 16) : EdgeInsets.zero,
            child: is_expand
                ? TextField(
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      //  Gọi hành động khi người dùng nhấn "done"
                      FocusScope.of(context).unfocus(); // Ẩn bàn phím
                      print("Note đã nhập: $value");
                    },
                    style: GoogleFonts.poppins(fontSize: 12),
                    onChanged: (value) {
                      context.read<OrderProvider>().setNoteOrder(value);
                    },
                    controller: _noteForOrder,
                 
                    maxLines: null,
                    expands: true,

                    decoration: InputDecoration(
                      hintText: "Enter your notes here...",
                      hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade400, fontSize: 12),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      //contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }
}
