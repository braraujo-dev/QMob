class ProfileEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? phone;
  
  // Dados do Veículo
  final String? vehicleModel;
  final String? vehiclePlate;
  final String? vehicleColor;

  // Campos de Admin (mantendo suporte se necessário)
  final String? nomeSindicato;
  final String? cnpj;
  final String? responsavel;

  ProfileEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.phone,
    this.vehicleModel,
    this.vehiclePlate,
    this.vehicleColor,
    this.nomeSindicato,
    this.cnpj,
    this.responsavel,
  });

  bool get isAdmin => nomeSindicato != null;
}
