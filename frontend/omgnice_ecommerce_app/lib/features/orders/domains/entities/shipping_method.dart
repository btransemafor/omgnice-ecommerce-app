class ShippingMethodEntity {
  final String ? id; 
  final String ? description; 
  final String ? name; 
  final double? price; 
  final double? discountPrice;

  const ShippingMethodEntity({
    this.id, 
    this.description, 
    this.discountPrice, 
    this.name, 
    this.price, 
  }); 
}