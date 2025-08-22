import 'package:omgnice_ecommerce_app/features/user/domain/entities/userStats.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/repositories/user_repository.dart';

class FetchStatisticsUsecase  {
  final UserRepository userRepository; 
  const FetchStatisticsUsecase({
    required this.userRepository 
  }); 
  Future<Userstats> call(String user_id) async {
    return userRepository.getStatisticsUser(user_id); 
  }
}