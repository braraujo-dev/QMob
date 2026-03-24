// UserModel
import 'package:alternative/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.role, // Adicionado
  });

  factory UserModel.fromSupabase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'] ?? 'user', // Valor padrão caso venha nulo
    );
  }
}
