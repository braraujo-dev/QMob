import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

abstract class ILocationService {
  Future<bool> checkPermission();
  Stream<Position> getPositionStream();
  Future<Position> getCurrentPosition();
  Future<String?> getCityFromCoordinates(double lat, double lng);
  double calculateDistance(double startLat, double startLng, double endLat, double endLng);
}

class LocationService implements ILocationService {
  @override
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    
    if (permission == LocationPermission.deniedForever) return false;
    
    return true;
  }

  @override
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  @override
  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  @override
  Future<String?> getCityFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality;
      }
    } catch (_) {}
    return null;
  }

  @override
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
