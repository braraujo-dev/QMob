import 'package:alternative/core/utils/enum_class.dart';

class DriverEntity {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserType userType;
  final String vehicleModel;
  final String vehicleColor;
  final String vehiclePlate;
  final double assignedCapital;
  final String? photoUrl;

  DriverEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.userType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.assignedCapital,
    this.photoUrl,
  });
}
