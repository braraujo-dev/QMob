import '../../domain/entities/historic_entity.dart';

class HistoricModel extends HistoricEntity {
  HistoricModel({
    required super.id,
    required super.origin,
    required super.destination,
    required super.date,
    required super.status,
    super.price,
  });

  factory HistoricModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['date']);
    if (!parsedDate.isUtc) {
      parsedDate = DateTime.parse(json['date'] + 'Z');
    }

    return HistoricModel(
      id: json['id']?.toString() ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      date: parsedDate.toLocal(),
      status: json['status'] ?? '',
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'destination': destination,
      'date': date.toUtc().toIso8601String(),
      'status': status,
      'price': price,
    };
  }
}
