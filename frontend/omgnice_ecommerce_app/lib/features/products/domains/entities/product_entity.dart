class ProductEntity {
  final int id;
  final String name; 
  final String description; 
  final int stockQuantity; 
  final String imageUrl; 
  final int discount_percent; 
  final int category_id; 
  final int soldQuantity;

  const ProductEntity({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.stockQuantity, 
    required this.imageUrl, 
    required this.discount_percent, 
    required this.category_id, 
    required this.soldQuantity
  });

  ProductEntity copyWith({
    int? id, 
    String? name, 
    String? description,
    int? stockQuantity, 
    String? imageUrl, 
    int? discount_percent, 
    int? category_id , 
    int? soldQuantity
  }) {
    return ProductEntity(
      id: id ?? this.id, 
      name: name?? this.name, 
      description: description ?? this.name,
      stockQuantity: stockQuantity ?? this.stockQuantity, 
      imageUrl: imageUrl ?? this.imageUrl, 
      discount_percent: discount_percent ?? this.discount_percent, 
      category_id: category_id ?? this.category_id, 
      soldQuantity : soldQuantity ?? this.soldQuantity 
    ); 
  }
}

