import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/capital_entity.dart';
import '../../domain/repositories/checkin_repository.dart';

class CheckinRepositoryImpl implements CheckinRepository {
  final Map<String, Map<String, dynamic>> _nordesteCapitals = {
    'João Pessoa': {'coords': const LatLng(-7.1153, -34.8610), 'radius': 7000.0},
    'Recife': {'coords': const LatLng(-8.0578, -34.8829), 'radius': 7000.0},
    'Maceió': {'coords': const LatLng(-9.6658, -35.7350), 'radius': 7000.0},
    'Aracaju': {'coords': const LatLng(-10.9472, -37.0731), 'radius': 7000.0},
    'Salvador': {'coords': const LatLng(-12.9714, -38.5014), 'radius': 7000.0},
    'Natal': {'coords': const LatLng(-5.7945, -35.2110), 'radius': 7000.0},
    'Fortaleza': {'coords': const LatLng(-3.7319, -38.5267), 'radius': 7000.0},
    'Teresina': {'coords': const LatLng(-5.0920, -42.8038), 'radius': 7000.0},
    'São Luís': {'coords': const LatLng(-2.5307, -44.3068), 'radius': 7000.0},
  };

  @override
  Future<List<CapitalEntity>> getCapitals() async {
    return _nordesteCapitals.entries.map((e) => CapitalEntity(
      cityName: e.key,
      coords: e.value['coords'],
      radius: e.value['radius'],
    )).toList();
  }

  @override
  Future<CapitalEntity> getDestinationByCityName(String cityName) async {
    final data = _nordesteCapitals[cityName] ?? _nordesteCapitals['João Pessoa']!;
    return CapitalEntity(
      cityName: cityName,
      coords: data['coords'],
      radius: data['radius'],
    );
  }
}
