import 'package:omgnice_ecommerce_app/features/user/domain/entities/userStats.dart';

class UserEntity {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final int? point;
  final int? roleId;
  final String? avatar; 
  final bool? active; 
  final DateTime? createdAt; 
  final Userstats? userstats; 
  final bool isActive; 
  final String? pwRandom;

  const UserEntity({
    this.pwRandom,
    this.id,
    this.name,
    this.email,
    this.phone,
    this.point,
    this.roleId,
    this.avatar, 
    this.active, 
    this.createdAt, 
    this.userstats, 
    required this.isActive
  });

  UserEntity copyWith({
    bool? isActive,
    String? id,
    String? name,
    String? email,
    String? phone,
    int? point,
    int? roleId,
    String? avatar, 
    bool? active, 
    Userstats? userStats,
    String? pwRandom
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      point: point ?? this.point,
      roleId: roleId ?? this.roleId,
      avatar: avatar ?? this.avatar, 
      active: active ?? this.active,
      userstats: userStats ?? this.userstats, 
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      pwRandom: pwRandom ?? this.pwRandom,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          point == other.point &&
          roleId == other.roleId &&
          avatar == other.avatar &&
          isActive == other.isActive &&
          createdAt == other.createdAt &&
          pwRandom == other.pwRandom;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      point.hashCode ^
      roleId.hashCode ^
      avatar.hashCode ^
      createdAt.hashCode ^
      pwRandom.hashCode ^
      isActive.hashCode;
}