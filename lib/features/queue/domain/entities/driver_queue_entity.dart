class DriverQueueEntity {
  final String id;
  final String name;
  final String vehicle;
  final String color;
  final String arrivalTime;
  final String cityName;
  final int position;
  final bool isCurrentUser;

  DriverQueueEntity({
    required this.id,
    required this.name,
    required this.vehicle,
    required this.color,
    required this.arrivalTime,
    required this.cityName,
    required this.position,
    this.isCurrentUser = false,
  });
}
