import 'package:alternative/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.role,
    super.baseCity,
  });

  factory UserModel.fromSupabase(Map<String, dynamic> json, {String? baseCity, bool isAdmin = false}) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      baseCity: baseCity,
    );
  }
}
