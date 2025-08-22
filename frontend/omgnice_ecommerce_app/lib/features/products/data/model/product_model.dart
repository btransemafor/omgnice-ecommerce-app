import 'package:omgnice_ecommerce_app/features/products/domains/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  final int id;
  final String name;
  final String description;
  final int stockQuantity;
  final String imageUrl;
  final int discount_percent;
  final int category_id;
  final int soldQuantity;
  
  const ProductModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.stockQuantity,
      required this.imageUrl,
      required this.discount_percent,
      required this.category_id,
      required this.soldQuantity})
      : super(
            id: id,
            name: name,
            description: description,
            stockQuantity: stockQuantity,
            imageUrl: imageUrl,
            discount_percent: discount_percent,
            category_id: category_id,
            soldQuantity: soldQuantity);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'] as int,
        name: json['name_product'] as String,
        description: json['description'] as String,
        stockQuantity: json['stockQuantity'] as int,
        soldQuantity: json["soldQuantity"] as int,
        imageUrl: json['imageUrl'] as String,
        category_id: json['category_id'] as int,
        discount_percent: json['discount_percent'] as int);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name_product": name,
      "description": description,
      "soldQuantity": soldQuantity,
      "stockQuantity": stockQuantity,
      "imageUrl": imageUrl,
      "discount_percent": discount_percent,
      "category_id": category_id
    };
  }
}
