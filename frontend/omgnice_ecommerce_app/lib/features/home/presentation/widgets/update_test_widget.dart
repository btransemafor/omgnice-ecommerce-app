import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UploadTestWidget extends StatefulWidget {
  const UploadTestWidget({super.key});

  @override
  State<UploadTestWidget> createState() => _UploadTestWidgetState();
}

class _UploadTestWidgetState extends State<UploadTestWidget> {
  File? _selectedImage;
  String? _downloadUrl;
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _isUploading = true;
    });

    try {
      final fileName = path.basename(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child('test_uploads/$fileName');
      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask;

      final url = await snapshot.ref.getDownloadURL();

      setState(() {
        _downloadUrl = url;
        _isUploading = false;
      });

      debugPrint("✅ Uploaded successfully: $url");
    } catch (e) {
      debugPrint("❌ Upload failed: $e");
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top:100),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _isUploading ? null : _pickAndUploadImage,
                  child: const Text("🖼️ Chọn ảnh & Upload"),
                ),
                if (_isUploading) const CircularProgressIndicator(),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.file(_selectedImage!, height: 150),
                  ),
                if (_downloadUrl != null)
                  SelectableText("🔥 Link ảnh: $_downloadUrl", style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        )
    );
  }
}