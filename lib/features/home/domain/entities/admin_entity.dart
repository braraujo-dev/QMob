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
}
