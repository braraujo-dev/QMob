import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/capital_entity.dart';
import 'checkin_state.dart';

class CheckinController extends ValueNotifier<CheckinState> {
  StreamSubscription<Position>? _positionStream;
  String _cachedCity = "";

  CheckinController(CapitalEntity destination) 
      : super(CheckinState(destination: destination));

  void startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, 
        distanceFilter: 10
      ),
    ).listen(_updatePosition);
  }

  void stopTracking() {
    _positionStream?.cancel();
  }

  Future<void> _updatePosition(Position position) async {
    final destination = value.destination;
    
    final distance = Geolocator.distanceBetween(
      position.latitude, position.longitude,
      destination.coords.latitude, destination.coords.longitude,
    );

    bool insideByDistance = distance <= destination.radius;
    bool insideByCity = false;

    if (distance < 25000 && _cachedCity.isEmpty) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude
        );
        if (placemarks.isNotEmpty) {
          _cachedCity = placemarks[0].locality ?? "";
          insideByCity = _cachedCity.toLowerCase().contains(destination.cityName.toLowerCase());
        }
      } catch (_) {}
    } else if (_cachedCity.isNotEmpty) {
      insideByCity = _cachedCity.toLowerCase().contains(destination.cityName.toLowerCase());
    }

    final bool isNowInside = insideByDistance || insideByCity;

    String status;
    if (isNowInside) {
      status = "No Local";
    } else if (position.speed > 0.5) {
      status = "Em Rota";
    } else {
      status = "Aguardando";
    }

    String eta;
    if (isNowInside) {
      eta = "Já chegou";
    } else {
      final minutesToArrival = (distance / 1000).ceil();
      final arrivalDateTime = DateTime.now().add(Duration(minutes: minutesToArrival));
      eta = DateFormat('HH:mm').format(arrivalDateTime);
      if (arrivalDateTime.day != DateTime.now().day) eta += " (+1d)";
    }

    value = value.copyWith(
      distanceToCenter: distance,
      isInsideGeofence: isNowInside,
      status: status,
      arrivalTime: eta,
      speed: position.speed,
    );
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
