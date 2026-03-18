class DriverEntity {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String vehicleModel;
  final String vehicleColor;
  final String vehiclePlate;
  final double assignedCapital;

  DriverEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.assignedCapital,
  });
}
