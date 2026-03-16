// Especialização para Motorista
import 'package:alternative/features/profile/domain/entities/profile_entity.dart';

class DriverProfileEntity extends ProfileEntity {
  final String name;
  final String? photoUrl;

  DriverProfileEntity({required super.id, required super.email, required this.name, this.photoUrl});
}
