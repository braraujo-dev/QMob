import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({required super.id, required super.email, required super.name, super.phone});

  // Este factory serve para converter dados básicos que existem em ambas as tabelas
  factory ProfileModel.fromJson(Map<String, dynamic> json, String email) {
    return ProfileModel(
      id: json['id'],
      email: email,
      name: json['full_name'] ?? '',
      phone: json['phone'],
    );
  }

  // ToJson genérico para colunas que existem em qualquer perfil
  Map<String, dynamic> toJson() {
    return {'full_name': name, 'phone': phone};
  }
}
