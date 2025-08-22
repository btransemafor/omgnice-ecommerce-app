
import 'package:omgnice_ecommerce_app/features/orders/data/sources/remote/shipping_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/repositories/shipping_repository.dart';

class ShippingRepositoryImpl implements ShippingRepository {
  final ShippingRemoteSource shippingRemoteSource; 
  const ShippingRepositoryImpl({required this.shippingRemoteSource}); 

  @override
  Future<List<ShippingMethodEntity>> getShippingMethods() async {
    // Chuyen thanh list Entity 
    try {
      final listModel = await shippingRemoteSource.getShippingMethods();
      return listModel.map((itemModel) => ShippingMethodEntity(
          id: itemModel.id,
          name: itemModel.name,
          description: itemModel.description,
          price: itemModel.price,
          discountPrice: itemModel.discountPrice
      )).toList();
    } catch (e) {
      throw Exception('Failed to get shipping methods: $e');
    }
  }
}