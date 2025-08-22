import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/user/data/models/user_stats.dart';

class UserModel extends UserEntity {
  final String? accessToken;
  final String? refreshToken;

  const UserModel({
    String? id,
    String? name,
    String? phone,
    String? email,
    required bool isActive,
    int? point,
    int? roleId,
    String? avatar,
    bool? active,
    UserStatsModel? userStats,
    DateTime? createdAt,
    this.accessToken,
    this.refreshToken,
    String? pwRandom
  }) : super(
          isActive: isActive,
          id: id,
          name: name,
          phone: phone,
          email: email,
          point: point,
          roleId: roleId,
          avatar: avatar,
          active: active,
          userstats: userStats,
          createdAt: createdAt,
          pwRandom: pwRandom,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isActive: json['is_active'],
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?, 
      point: json['point'] as int?,
      roleId: json['role_id'] is int
          ? json['role_id']
          : int.tryParse(json['role_id']?.toString() ?? ''),
      avatar: json['avatar'] as String?,
      active: json['active'] as bool?,
      userStats: json['statistics'] != null
          ? UserStatsModel.fromJson(json['statistics'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String? ?? '')
          : null,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      pwRandom: json['pwRandom'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'point': point,
      'role_id': roleId,
      'avatar': avatar,
      'active': active,
      'createdAt': createdAt?.toIso8601String(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'is_active': isActive
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      isActive: entity.isActive,
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      point: entity.point,
      roleId: entity.roleId,
      avatar: entity.avatar,
      active: entity.active,
      userStats: entity.userstats as UserStatsModel?,
      createdAt: entity.createdAt,
      pwRandom: entity.pwRandom,
    );
  }
}
