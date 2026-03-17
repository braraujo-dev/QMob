import '../../domain/entities/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel({
    super.id,
    required super.name,
    required super.email,
    required super.city,
    required super.cpf,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'city': city,
      'cpf': cpf,
      'is_admin': false, // Motoristas não são admins por padrão
    };
  }
}
