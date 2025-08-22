import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MoMoPaymentScreen extends StatefulWidget {
  @override
  _MoMoPaymentScreenState createState() => _MoMoPaymentScreenState();
}

class _MoMoPaymentScreenState extends State<MoMoPaymentScreen> {
  bool isLoading = false;
  String? paymentUrl;
  String? orderId;

  Future<void> createPayment() async {
    setState(() => isLoading = true);

    try {
      orderId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
      final response = await http.post(
        Uri.parse('https://3d35-2401-d800-b9c2-1854-9113-1770-cedb-9b99.ngrok-free.app/create-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': 10000,
          'orderId': orderId,
          'orderInfo': 'Thanh toán đơn hàng test',
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);
      if (data['resultCode'] == 0) {
        setState(() {
          paymentUrl = data['payUrl'];
        });
        print('PayUrl: $paymentUrl');

        if (paymentUrl != null) {
          final uri = Uri.parse(paymentUrl!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: LaunchMode.externalNonBrowserApplication, // Mở MoMo Test App
            );
          } else {
            throw 'Không thể mở MoMo';
          }
        } else {
          throw 'Không nhận được payUrl từ server.';
        }
      } else {
        throw 'Lỗi từ MoMo: ${data['message']}';
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> checkPaymentStatus() async {
    if (orderId == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://3d35-2401-d800-b9c2-1854-9113-1770-cedb-9b99.ngrok-free.app/payment-status/$orderId'),
      );
      print('Payment status: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trạng thái: ${response.body}')),
      );
    } catch (e) {
      print('Error checking status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kiểm tra trạng thái: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thanh toán MoMo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) CircularProgressIndicator(),
            ElevatedButton(
              onPressed: createPayment,
              child: Text('Thanh toán 10,000 VND'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkPaymentStatus,
              child: Text('Kiểm tra trạng thái'),
            ),
          ],
        ),
      ),
    );
  }
}