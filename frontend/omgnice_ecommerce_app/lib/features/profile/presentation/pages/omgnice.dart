import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _image;

  // Các TextEditingController cho các trường nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _soldQuantityController = TextEditingController();
  final TextEditingController _stockQuantityController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadProduct() async {
    if (_image == null) return;

    var uri = Uri.parse("http://192.168.102.242:8081/api/products/"); // Địa chỉ backend của bạn
    var request = http.MultipartRequest("POST", uri);

    // Thêm các trường dữ liệu khác từ controller
    request.fields['name_product'] = _nameController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['soldQuantity'] = _soldQuantityController.text;
    request.fields['stockQuantity'] = _stockQuantityController.text;
    request.fields['category_id'] = _categoryIdController.text;
    request.fields['discount_percent'] = _discountController.text;

    // Thêm file ảnh
    var stream = http.ByteStream(_image!.openRead());
    var length = await _image!.length();
    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: basename(_image!.path),
    );

    request.files.add(multipartFile);

    // Thêm Token vào Header
    request.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjcwYjE1NTFmLWUzN2EtNDMyMC1iYWNhLWI3ZTExMDNkNzlmNyIsImVtYWlsIjoidHJhbnZvaXNsb2FkaW5nQGdtYWlsLmNvbSIsInJvbGVfaWQiOjIsImlhdCI6MTc0Mzk2MTcxNiwiZXhwIjoxNzQzOTY1MzE2fQ.7oRyrHoGmZgkASDAznWhsggZnOcH65qA7l-ZbHoxG_I';
    request.headers['Accept'] = 'application/json';

    print('📤 Uploading...');
    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      print("✅ Upload thành công!");
      print("📥 Response: $responseData");
    } else {
      print("❌ Lỗi khi upload: ${response.statusCode}");
      print("📥 Response: $responseData");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả sản phẩm'),
              ),
              TextField(
                controller: _soldQuantityController,
                decoration: InputDecoration(labelText: 'Số lượng đã bán'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _stockQuantityController,
                decoration: InputDecoration(labelText: 'Số lượng tồn kho'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _categoryIdController,
                decoration: InputDecoration(labelText: 'ID Danh mục'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _discountController,
                decoration: InputDecoration(labelText: 'Phần trăm giảm giá'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _image == null
                  ? Text("Chưa chọn ảnh")
                  : Image.file(_image!, height: 200),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Chọn ảnh"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadProduct,
                child: Text("Tải lên"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
