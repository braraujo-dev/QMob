import '../../domain/entities/capital_entity.dart';

class CheckinState {
  final CapitalEntity destination;
  final double distanceToCenter;
  final bool isInsideGeofence;
  final String arrivalTime;
  final String status;
  final double speed;
  final bool isAlreadyInQueue;
  final bool isLoading;

  CheckinState({
    required this.destination,
    this.distanceToCenter = 0,
    this.isInsideGeofence = false,
    this.arrivalTime = '--:--',
    this.status = 'Aguardando',
    this.speed = 0,
    this.isAlreadyInQueue = false,
    this.isLoading = false,
  });

  CheckinState copyWith({
    CapitalEntity? destination,
    double? distanceToCenter,
    bool? isInsideGeofence,
    String? arrivalTime,
    String? status,
    double? speed,
    bool? isAlreadyInQueue,
    bool? isLoading,
  }) {
    return CheckinState(
      destination: destination ?? this.destination,
      distanceToCenter: distanceToCenter ?? this.distanceToCenter,
      isInsideGeofence: isInsideGeofence ?? this.isInsideGeofence,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      status: status ?? this.status,
      speed: speed ?? this.speed,
      isAlreadyInQueue: isAlreadyInQueue ?? this.isAlreadyInQueue,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
