import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/location_service.dart';
import '../../../queue/domain/usecases/is_user_in_queue_usecase.dart';
import '../../../queue/domain/usecases/perform_checkin_usecase.dart';
import '../../domain/entities/capital_entity.dart';
import '../../domain/usecases/get_checkin_status_usecase.dart';
import 'checkin_state.dart';

class CheckinController extends ValueNotifier<CheckinState> {
  final ILocationService locationService;
  final GetCheckinStatusUseCase getCheckinStatusUseCase;
  final PerformCheckinUseCase performCheckinUseCase;
  final IsUserInQueueUseCase isUserInQueueUseCase;

  StreamSubscription<Position>? _positionStream;
  String? _cachedCity;

  CheckinController({
    required CapitalEntity destination,
    required this.locationService,
    required this.getCheckinStatusUseCase,
    required this.performCheckinUseCase,
    required this.isUserInQueueUseCase,
  }) : super(CheckinState(destination: destination));

  void startTracking() async {
    try {
      final inQueue = await isUserInQueueUseCase();
      value = value.copyWith(isAlreadyInQueue: inQueue);
    } catch (e) {}

    final hasPermission = await locationService.checkPermission();
    if (!hasPermission) {
      return;
    }

    _positionStream = locationService.getPositionStream().listen((pos) {
      _updatePosition(pos);
    });
  }

  void stopTracking() {
    _positionStream?.cancel();
  }

  Future<void> performCheckin() async {
    if (value.isAlreadyInQueue || !value.isInsideGeofence) return;

    value = value.copyWith(isLoading: true);
    try {
      await performCheckinUseCase(value.destination.cityName);
      value = value.copyWith(isAlreadyInQueue: true, isLoading: false);
    } catch (e) {
      value = value.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> _updatePosition(Position position) async {
    final destination = value.destination;

    final distance = locationService.calculateDistance(
      position.latitude,
      position.longitude,
      destination.coords.latitude,
      destination.coords.longitude,
    );

    if (distance < 25000 && _cachedCity == null) {
      _cachedCity = await locationService.getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );
    }

    final isInside = getCheckinStatusUseCase.isInsideGeofence(
      currentPosition: position,
      destination: destination,
      currentCity: _cachedCity,
    );

    final status = getCheckinStatusUseCase.calculateStatus(
      isInside: isInside,
      speed: position.speed,
    );

    String eta;
    if (isInside) {
      eta = "Já chegou";
    } else {
      final minutesToArrival = (distance / 1000).ceil();
      final arrivalDateTime = DateTime.now().add(Duration(minutes: minutesToArrival));
      eta = DateFormat('HH:mm').format(arrivalDateTime);
      if (arrivalDateTime.day != DateTime.now().day) eta += " (+1d)";
    }

    value = value.copyWith(
      distanceToCenter: distance,
      isInsideGeofence: isInside,
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
