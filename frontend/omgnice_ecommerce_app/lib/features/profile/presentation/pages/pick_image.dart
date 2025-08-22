import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();

        setState(() {
          _imageBytes = imageBytes;
        });

        print('Image selected successfully!');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Screen'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBytes != null
                ? Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(
                  _imageBytes!,
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Text(
              'No image selected.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image from Gallery'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> captureImage() async {
    try {
      final XFile? capturedFile = await _picker.pickImage(source: ImageSource.camera);

      if (capturedFile != null) {
        final Uint8List imageBytes = await capturedFile.readAsBytes();

        setState(() {
          _imageBytes = imageBytes;
        });

        print('Image captured successfully!');
      } else {
        print('No image captured.');
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Capture Screen'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBytes != null
                ? Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(
                  _imageBytes!,
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Text(
              'No image captured.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: captureImage,
              // ignore: sort_child_properties_last
              child: Text('Capture Image from Camera'),
              style: ElevatedButton.styleFrom(
               // primary: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

