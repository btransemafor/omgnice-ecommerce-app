import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/entities/userStats.dart';

abstract class UserRepository {
  Future<Userstats> getStatisticsUser(String user_id); 
  Future<bool> updateUser(Map<String, String> updateData, [String? user_id]); 
  Future<UserEntity> getProfileUser([String? user_id]); 
  Future<List<UserEntity>> fetchAllUser();
  Future<bool> updateUserPoint(int amount); 
  Future<bool> deteleUser([String? user_id]); 
}