// features/settings/data/models/profile_model.dart
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    required super.isAdmin,
    // Adicione os campos extras do seu script SQL aqui se necessário
    String? cnpj,
    String? responsavel,
    String? telefone,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json, String userEmail) {
    return ProfileModel(
      id: json['id'],
      name: json['nome_sindicato'] ?? 'Sem nome', // Mapeando seu script SQL
      email: userEmail,
      photoUrl: json['avatar_url'],
      isAdmin: json['is_admin'] ?? false,
    );
  }
}
