import 'package:alternative/core/utils/enum_class.dart';
import 'package:alternative/features/home/domain/entities/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel({
    required super.id,
    required super.email,
    required super.name,
    required super.phone,
    required super.userType,
    super.photoUrl,
    required super.vehicleModel,
    required super.vehicleColor,
    required super.vehiclePlate,
    required super.assignedCapital,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['full_name'] ?? '',
      phone: map['phone'] ?? '',
      userType: UserType.values.firstWhere(
        (e) => e.name == map['user_type'],
        orElse: () => UserType.driver,
      ),
      photoUrl: map['photo_url'],
      vehicleModel: map['vehicle_model'] ?? '',
      vehicleColor: map['vehicle_color'] ?? '',
      vehiclePlate: map['vehicle_plate'] ?? '',
      assignedCapital: (map['assigned_capital'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': name,
      'phone': phone,
      'user_type': userType.name,
      'photo_url': photoUrl,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'vehicle_plate': vehiclePlate,
      'assigned_capital': assignedCapital,
    };
  }
}
