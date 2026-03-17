import 'package:intl/intl.dart';
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

  factory DriverQueueModel.fromJson(Map<String, dynamic> json, String currentUserId, int index) {
    String formattedTime = '--:--';
    
    if (json['checkin_time'] != null) {
      try {
        DateTime dt = DateTime.parse(json['checkin_time']);
        
        if (!dt.isUtc) {
          dt = DateTime.parse(json['checkin_time'] + 'Z');
        }
        
        formattedTime = DateFormat('HH:mm').format(dt.toLocal());
      } catch (e) {
        print('Erro ao formatar data: $e');
      }
    }

    return DriverQueueModel(
      id: json['id']?.toString() ?? '',
      name: json['profiles']?['full_name'] ?? 'Motorista',
      vehicle: json['profiles']?['vehicle_model'] ?? 'Veículo',
      color: json['profiles']?['vehicle_color'] ?? '',
      arrivalTime: formattedTime,
      position: index + 1,
      isCurrentUser: json['driver_id'] == currentUserId,
    );
  }
}
