import '../../domain/entities/driver_queue_entity.dart';

class DriverQueueModel extends DriverQueueEntity {
  DriverQueueModel({
    required super.id,
    required super.name,
    required super.vehicle,
    required super.color,
    required super.arrivalTime,
    required super.position,
    super.isCurrentUser,
  });

  factory DriverQueueModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    return DriverQueueModel(
      id: json['id']?.toString() ?? '',
      name: json['profiles']?['full_name'] ?? 'Motorista',
      vehicle: json['profiles']?['vehicle_model'] ?? 'Veículo',
      color: json['profiles']?['vehicle_color'] ?? '',
      arrivalTime: json['checkin_time'] ?? '',
      position: json['queue_position'] ?? 0,
      isCurrentUser: json['driver_id'] == currentUserId,
    );
  }
}
