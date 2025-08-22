class Product {
  String? id;
  final String name;
   String? imageUrl;
  final String description;
  final bool isHidden; 
  final int? soldQuantity; 
  final int category_id; 
  final int discountPercent; 
  final Map<String, double> variants;

  Product({
    this.id,
    required this.name,
     this.imageUrl,
    required this.description,
    required this.isHidden, 
    this.soldQuantity,
    required this.category_id,  
    required this.discountPercent, 
    required this.variants, 
  });
}
extension ProductCopy on Product {
  Product copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    bool? isHidden,
    int? soldQuantity,
    int? category_id,
    int? discountPercent,
    Map<String, double>? variants,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isHidden: isHidden ?? this.isHidden,
      soldQuantity: soldQuantity ?? this.soldQuantity,
      category_id: category_id ?? this.category_id,
      discountPercent: discountPercent ?? this.discountPercent,
      variants: variants ?? this.variants,
    );
  }
}
