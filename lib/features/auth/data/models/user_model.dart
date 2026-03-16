import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id, 
    required super.email, 
    super.isAdmin,
    super.baseCity,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      baseCity: json['base_city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'is_admin': isAdmin,
      'base_city': baseCity,
    };
  }
}
