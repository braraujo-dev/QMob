import 'package:alternative/features/home/domain/entities/admin_entity.dart';

class AdminModel extends AdminEntity {
  AdminModel({
    required super.id,
    required super.email,
    required super.name,
    super.phone,
    required super.nomeSindicato,
    required super.cnpj,
    required super.responsavel,
    required super.contato,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['full_name'] ?? '',
      phone: map['phone'],
      nomeSindicato: map['nome_sindicato'] ?? '',
      cnpj: map['cnpj'] ?? '',
      responsavel: map['responsavel'] ?? '',
      contato: map['contato'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': name,
      'phone': phone,
      'nome_sindicato': nomeSindicato,
      'cnpj': cnpj,
      'responsavel': responsavel,
      'contato': contato,
    };
  }
}
