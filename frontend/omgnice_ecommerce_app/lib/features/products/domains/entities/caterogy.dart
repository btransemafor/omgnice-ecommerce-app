void main() {
  List<CategoryModel> categories = CategoryModel.getSampleCategories();
  categories.forEach((category) {
    print('ID: ${category.id}, Name: ${category.name}');
  });
}

class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  // Phương thức tạo danh sách mẫu
  static List<CategoryModel> getSampleCategories() {
    return [
      CategoryModel(id: 1, name: 'Điện thoại'),
      CategoryModel(id: 2, name: 'Laptop'),
      CategoryModel(id: 3, name: 'Máy tính bảng'),
      CategoryModel(id: 4, name: 'Phụ kiện'),
      CategoryModel(id: 5, name: 'Yogurt'),
      CategoryModel(id: 6, name: 'Milk Tea'),

    ];
  }

  // Factory từ JSON (dùng cho remote data)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['category_name'] as String,
    );
  }

  // Chuyển về JSON (nếu cần post / put)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': name,
    };
  }
}
