import 'dart:convert';
import '../domain/entity/product.dart';

Map<String, dynamic> extractChangedFields(Product updated, Product original) {
  final map = <String, dynamic>{};
  
  if (updated.name != original.name) map['name'] = updated.name;
  if (updated.description != original.description) map['description'] = updated.description;
  if (updated.discountPercent != original.discountPercent) {
    map['discount_percent'] = updated.discountPercent;
  }
  if (updated.isHidden != original.isHidden) {
    map['isHidden'] = updated.isHidden.toString();
  }
  if (updated.imageUrl != original.imageUrl) {
    map['imageUrl'] = updated.imageUrl; 
  }
  if (updated.category_id != original.category_id) {
    map['category_id'] = updated.category_id;
  }
  if (updated.variants.toString() != original.variants.toString()) {
    map['variants'] = jsonEncode(updated.variants);
  }

  return map;
}
