import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String baseUrl = 'http://192.168.213.242:8081/api';

// lib/core/constants/constants.dart

enum VerificationFlow {
  register,
  loginUnverified,
  forgotPassword,
}

final List<String> times = [
  'Giao ngay',
  '8:00 - 9:00',
  '9:00 - 10:00',
  '15:00 - 16:00',
  '17:00 - 18:00',
  'Tối 19:00 - 20:00',
];

List<Map<String, dynamic>> drinkList = [
  {
    'name': 'Frosted Espresso with Caramel Drizzle',
    'price': 30000.0,
    'imageUrl': 'https://example.com/images/frosted_espresso.jpg',
    'description': 'Rich espresso with caramel drizzle for a sweet finish.',
  },
  {
    'name': 'Hazelnut Tiramisu Brew with Dark Chocolate',
    'price': 32000.0,
    'imageUrl': 'https://example.com/images/hazelnut_tiramisu.jpg',
    'description':
        'A delicious combination of hazelnut and tiramisu with a hint of dark chocolate.',
  },
  {
    'name': 'Iced Green Tea with Lemon',
    'price': 25000.0,
    'imageUrl': 'https://example.com/images/iced_green_tea.jpg',
    'description': 'Refreshing iced green tea with a splash of lemon.',
  },
  {
    'name': 'Caramel Macchiato',
    'price': 27000.0,
    'imageUrl': 'https://example.com/images/caramel_macchiato.jpg',
    'description': 'A creamy and sweet caramel macchiato with espresso.',
  },
  {
    'name': 'Matcha Latte',
    'price': 28000.0,
    'imageUrl': 'https://example.com/images/matcha_latte.jpg',
    'description': 'Smooth matcha latte with a touch of vanilla.',
  },
  {
    'name': 'Cold Brew Coffee',
    'price': 29000.0,
    'imageUrl': 'https://example.com/images/cold_brew_coffee.jpg',
    'description': 'Brewed cold for a smooth and strong taste.',
  },
  {
    'name': 'Strawberry Smoothie',
    'price': 22000.0,
    'imageUrl': 'https://example.com/images/strawberry_smoothie.jpg',
    'description': 'A sweet and creamy smoothie with fresh strawberries.',
  },
  {
    'name': 'Choco Mint Frappe',
    'price': 35000.0,
    'imageUrl': 'https://example.com/images/choco_mint_frappe.jpg',
    'description':
        'Cool mint and rich chocolate frappe topped with whipped cream.',
  },
];

final styleTextTitle = GoogleFonts.poppins(
  fontSize: 17,
  fontWeight: FontWeight.w700,
  color: Colors.black87,
  letterSpacing: 0.5,
);
