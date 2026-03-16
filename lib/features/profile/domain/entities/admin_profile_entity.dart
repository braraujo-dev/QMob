import 'package:alternative/features/profile/domain/entities/profile_entity.dart';

class AdminProfileEntity extends ProfileEntity {
  @override
  final String nomeSindicato;
  @override
  final String cnpj;
  @override
  final String responsavel;
  @override
  final String telefone;

  AdminProfileEntity({
    required super.id,
    required super.email,
    required this.nomeSindicato,
    required this.cnpj,
    required this.responsavel,
    required this.telefone,
  });
}
