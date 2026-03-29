import 'package:alternative/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.role,
    super.baseCity,
    super.mustChangePassword,
  });

  factory UserModel.fromSupabase(Map<String, dynamic> json, {String? baseCity, bool mustChange = false}) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      role: json['role'] ?? 'driver',
      baseCity: baseCity,
      mustChangePassword: mustChange,
    );
  }
}
