// features/profile/domain/entities/profile_entity.dart
class ProfileEntity {
  final String id;
  final String email;
  // Campos de Driver
  final String? name;
  final String? photoUrl;
  // Campos de Admin
  final String? nomeSindicato;
  final String? cnpj;
  final String? responsavel;
  final String? telefone;

  ProfileEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.nomeSindicato,
    this.cnpj,
    this.responsavel,
    this.telefone,
  });

  bool get isAdmin => nomeSindicato != null;
}
