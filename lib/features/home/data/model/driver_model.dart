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

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'],
      name: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      vehicleModel: map['vehicle_model'] ?? '',
      vehicleColor: map['vehicle_color'] ?? '',
      vehiclePlate: map['vehicle_plate'] ?? '',
      assignedCapital: (map['assigned_capital'] ?? 0).toDouble(),
    );
  }

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
