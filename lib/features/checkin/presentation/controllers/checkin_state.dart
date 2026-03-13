import '../../domain/entities/capital_entity.dart';

class CheckinState {
  final CapitalEntity destination;
  final double distanceToCenter;
  final bool isInsideGeofence;
  final String arrivalTime;
  final String status;
  final double speed;

  CheckinState({
    required this.destination,
    this.distanceToCenter = 0,
    this.isInsideGeofence = false,
    this.arrivalTime = '--:--',
    this.status = 'Aguardando',
    this.speed = 0,
  });

  CheckinState copyWith({
    CapitalEntity? destination,
    double? distanceToCenter,
    bool? isInsideGeofence,
    String? arrivalTime,
    String? status,
    double? speed,
  }) {
    return CheckinState(
      destination: destination ?? this.destination,
      distanceToCenter: distanceToCenter ?? this.distanceToCenter,
      isInsideGeofence: isInsideGeofence ?? this.isInsideGeofence,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      status: status ?? this.status,
      speed: speed ?? this.speed,
    );
  }
}
