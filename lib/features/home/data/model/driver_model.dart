import 'package:alternative/features/home/domain/entities/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel({
    super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.vehicleModel,
    required super.vehicleColor,
    required super.vehiclePlate,
    required super.assignedCapital,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'email': email,
      'phone': phone,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'vehicle_plate': vehiclePlate,
      'assigned_capital': assignedCapital,
    };
  }
}
