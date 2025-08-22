import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_detail_provider.dart';
import 'package:provider/provider.dart';

class ModalNoteOrder extends StatelessWidget {
  const ModalNoteOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailProvider>(context, listen: false);
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
           //   Color(0x80FF0000), // Đỏ
           //   Color(0x80FF7F00), // Cam
           //   Color(0x80FFFF00), // Vàng
             Color.fromARGB(255, 11, 109, 255), // Xanh lá
              Color.fromARGB(255, 3, 32, 9), // Xanh dương
             Color.fromARGB(128, 25, 123, 45), // Chàm
             // Color(0x808B00FF), // Tím
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius:  BorderRadius.circular(15),
                ),
                  child: Center(child: Text('Please add your note for your beverage', style: TextStyle(fontSize: 15, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w600)))),
              const SizedBox(height: 15),
              const CustomTextField(),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Xử lý lưu ghi chú ở đây
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Note saved successfully!'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color.fromARGB(255, 9, 148, 46),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),

                    /// Close Model
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Color(0xFF007AFF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CustomTextField extends StatefulWidget {
  const CustomTextField({Key? key}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductDetailProvider>(context, listen: false);
    _controller = TextEditingController(text: provider.noteForOrder);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailProvider>(
      builder: (context, provider, _) {
        return TextField(
          controller: _controller,
          maxLines: 5,
          onChanged: (value) {
            provider.saveNote(value); // Cập nhật Provider mỗi khi thay đổi
          },
          decoration: InputDecoration(
            hintText: 'Please Enter Your Note Order: ... ',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        );
      },
    );
  }
}
