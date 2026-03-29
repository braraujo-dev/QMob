class HistoricEntity {
  final String id;
  final String origin;
  final String destination;
  final DateTime date;
  final String status;
  final double? price;

  HistoricEntity({
    required this.id,
    required this.origin,
    required this.destination,
    required this.date,
    required this.status,
    this.price,
  });
}
