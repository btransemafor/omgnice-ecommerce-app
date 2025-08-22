import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';

abstract class ShippingRepository {
  Future<List<ShippingMethodEntity>> getShippingMethods(); 
}