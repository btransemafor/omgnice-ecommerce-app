import 'package:omgnice_ecommerce_app/features/orders/domains/entities/shipping_method.dart';
import 'package:omgnice_ecommerce_app/features/orders/domains/repositories/shipping_repository.dart';

class GetShippingUsecase {
  final ShippingRepository shippingRepository; 
  const GetShippingUsecase({required this.shippingRepository}); 

  Future<List<ShippingMethodEntity>> call() async {
    return shippingRepository.getShippingMethods(); 
  } 
}