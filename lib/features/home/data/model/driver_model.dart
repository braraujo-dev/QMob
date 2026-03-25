import 'package:alternative/features/home/domain/entities/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel({
    required super.id,
    required super.email,
    required super.name,
    required super.phone,
    super.photoUrl,
    required super.baseCity,
    required super.vehicleModel,
    required super.vehicleColor,
    required super.vehiclePlate,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['full_name'] ?? '',
      phone: map['phone'] ?? '',
      baseCity: map['base_city'] ?? '',
      photoUrl: map['photo_url'],
      vehicleModel: map['vehicle_model'] ?? '',
      vehicleColor: map['vehicle_color'] ?? '',
      vehiclePlate: map['vehicle_plate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': name,
      'phone': phone,
      'photo_url': photoUrl,
      'base_city': baseCity,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'vehicle_plate': vehiclePlate,
    };
  }
}
