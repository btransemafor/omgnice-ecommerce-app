import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatefulWidget {
  final bool obscureText;
  final String hintText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? errorText;
  final IconData? prefixIcon;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final TextInputAction? inputAction;
  final String? labelText; 
 

  const CustomFormField(
      {super.key,
      this.obscureText = false,
      required this.hintText,
      required this.onSaved,
      this.validator,
      this.onChanged,
      this.controller,
      this.errorText,
      this.prefixIcon,
      this.focus, 
      this.nextFocus, 
      this.inputAction, 
      this.labelText
      });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _obscure;

  @override
  void initState() {
    _obscure = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: widget.controller,
        
        obscureText: _obscure,
        onSaved: widget.onSaved,
        focusNode: widget.focus,
        validator: widget.validator,
        textInputAction: widget.inputAction,
        onFieldSubmitted: (_) {
          if (widget.nextFocus != null) {
            FocusScope.of(context).requestFocus(widget.nextFocus);
          } else {
            FocusScope.of(context)
                .unfocus(); // Đóng bàn phím nếu không có ô tiếp theo
          }
        },
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget
                .onChanged!(value); // Gọi lại hàm onChanged khi người dùng nhập
          }
        },
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color.fromARGB(255, 114, 111, 111),
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: size.height * 0.015,
            fontWeight: FontWeight.w300,
          ),
          errorStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.red.shade700,
            fontWeight: FontWeight.w400,
          ),
          labelText: widget.labelText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(widget.prefixIcon, color: Colors.green, size: 20),
                )
              : null,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.green.shade500,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.018,
          ),
        ),
      ),
    );
  }
}
