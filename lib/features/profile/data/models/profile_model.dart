// features/profile/data/models/profile_model.dart
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  final bool isAdminValue;

  ProfileModel({
    required super.id,
    required super.email,
    super.name, // Opcional para Admin
    super.photoUrl,
    super.nomeSindicato, // Opcional para Driver
    super.cnpj,
    super.responsavel,
    super.telefone,
    required this.isAdminValue,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json, String email, bool isAdmin) {
    return ProfileModel(
      id: json['id'],
      email: email,
      isAdminValue: isAdmin,
      // Se for admin, mapeia campos de sindicato, se não, campos de motorista
      name: json['nome'],
      photoUrl: json['foto_url'],
      nomeSindicato: json['nome_sindicato'],
      cnpj: json['cnpj'],
      responsavel: json['responsavel'],
      telefone: json['telefone'],
    );
  }
}
