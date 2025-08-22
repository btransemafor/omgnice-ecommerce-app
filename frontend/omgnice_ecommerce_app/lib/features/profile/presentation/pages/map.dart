import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenMapsScreen extends StatelessWidget {
  final String address = "Khu pho 6, Phuong Linh Trung, TP. Thu Duc"; // Địa chỉ bạn muốn mở trên Google Maps
  final double latitude = 10.870061570951597;
  final double longitude = 106.8034081469767;

  // 10.870061570951597, 106.8034081469767

  // Hàm mở Google Maps
  Future<void> _openGoogleMaps() async {
    final String googleMapsUrl = "https://www.google.com/maps?q=$latitude,$longitude";
    
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Open Google Maps")),
      body: Center(
        child: ElevatedButton(
          onPressed: _openGoogleMaps,
          child: Text("Open Google Maps"),
        ),
      ),
    );
  }
}
