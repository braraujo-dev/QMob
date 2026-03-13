import 'package:geolocator/geolocator.dart';
import '../entities/capital_entity.dart';

class GetCheckinStatusUseCase {
  const GetCheckinStatusUseCase();

  bool isInsideGeofence({
    required Position currentPosition,
    required CapitalEntity destination,
    String? currentCity,
  }) {
    final double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      destination.coords.latitude,
      destination.coords.longitude,
    );

    final bool insideByDistance = distance <= destination.radius;
    final bool insideByCity = currentCity != null && 
        currentCity.toLowerCase().contains(destination.cityName.toLowerCase());

    return insideByDistance || insideByCity;
  }

  String calculateStatus({
    required bool isInside,
    required double speed,
  }) {
    if (isInside) return "No Local";
    if (speed > 1) return "Em Rota";
    return "Aguardando";
  }
}
