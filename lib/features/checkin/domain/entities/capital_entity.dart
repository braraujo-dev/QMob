import 'package:google_maps_flutter/google_maps_flutter.dart';

class CapitalEntity {
  final LatLng coords;
  final String cityName;
  final double radius;

  CapitalEntity({
    required this.coords,
    required this.cityName,
    this.radius = 7000,
  });
}
