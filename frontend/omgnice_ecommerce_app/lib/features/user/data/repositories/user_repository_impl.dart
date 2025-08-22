import 'package:omgnice_ecommerce_app/features/auth/data/sources/firebase/google_sign_in_service.dart';
import 'package:omgnice_ecommerce_app/features/auth/data/sources/local/auth_local_data_source.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/user/data/remote/user_remote_source.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/entities/userStats.dart';
import 'package:omgnice_ecommerce_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteSource remoteSource;
  //final AuthService authService;
  final AuthLocalDataSource localSource;
  const UserRepositoryImpl(
      {required this.remoteSource, required this.localSource});

  @override
  Future<Userstats> getStatisticsUser(String user_id) async {
    return remoteSource.getStatisticUser(user_id);
  }

  @override
  Future<bool> updateUser(Map<String, String> updateData,
      [String? user_id]) async {
    return await remoteSource.updateUser(updateData, user_id);
  }

  @override
  Future<UserEntity> getProfileUser([String? user_id]) async {
    final user = await remoteSource.getProfileUser(user_id);
    await localSource.cacheUser(user);
    return user;
  }

  @override
  Future<List<UserEntity>> fetchAllUser() async {
    final data = remoteSource.fetchAllUser();
    print(data);
    return data;
  }

  @override
   Future<bool> updateUserPoint(int amount) async {
    return await remoteSource.updateUserPoint(amount); 
  }


  @override 
  Future<bool> deteleUser([String? user_id]) async {
    print("Attempting to delete user. user_id hehe: $user_id");
    return await remoteSource.deleteUser(user_id) ;
  }
}
