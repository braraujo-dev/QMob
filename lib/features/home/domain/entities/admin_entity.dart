class AdminEntity {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String nomeSindicato;
  final String cnpj;
  final String responsavel;
  final String contato;

  AdminEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.nomeSindicato,
    required this.cnpj,
    required this.responsavel,
    required this.contato,
  });

  AdminEntity copyWith({String? name, String? phone, String? responsavel, String? contato}) {
    return AdminEntity(
      id: id,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      nomeSindicato: nomeSindicato,
      cnpj: cnpj,
      responsavel: responsavel ?? this.responsavel,
      contato: contato ?? this.contato,
    );
  }
}
