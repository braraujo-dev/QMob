class DriverEntity {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String baseCity;
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
    required this.baseCity,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.assignedCapital,
    this.photoUrl,
  });

  DriverEntity copyWith({
    String? name,
    String? phone,
    String? vehicleModel,
    String? vehicleColor,
    String? vehiclePlate,
    String? photoUrl,
  }) {
    return DriverEntity(
      id: id,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      baseCity: baseCity,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      assignedCapital: assignedCapital,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
