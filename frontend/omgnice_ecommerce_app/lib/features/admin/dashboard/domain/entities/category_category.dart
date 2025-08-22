import 'dart:math';
import 'dart:ui';

class ProductCategory {
  final String nameCategory; // Tên gốc từ API (dùng cho thống kê)
  final double soldQuantity;
  final double sale;
  final Color randomColor;

  ProductCategory({
    required this.nameCategory,
    required this.soldQuantity,
    required this.sale,
    required this.randomColor,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      nameCategory: json['name'] ?? '',
      soldQuantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      sale: (json['total_sale'] as num?)?.toDouble() ?? 0.0,
      randomColor: getRandomColor()
    );
  }

}

Color getRandomColor() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  );
}