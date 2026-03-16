import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/services/location_service.dart';
import '../../../auth/domain/usecases/auth_usecase.dart';
import '../../../queue/domain/usecases/is_user_in_queue_usecase.dart';
import '../../../queue/domain/usecases/perform_checkin_usecase.dart';
import '../../domain/entities/capital_entity.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../../domain/usecases/get_checkin_status_usecase.dart';
import 'checkin_state.dart';

class CheckinController extends ValueNotifier<CheckinState> {
  final ILocationService locationService;
  final GetCheckinStatusUseCase getCheckinStatusUseCase;
  final PerformCheckinUseCase performCheckinUseCase;
  final IsUserInQueueUseCase isUserInQueueUseCase;
  final AuthUseCase authUseCase;
  final CheckinRepository checkinRepository;
  
  StreamSubscription<Position>? _positionStream;
  String? _cachedCity;

  CheckinController({
    required this.locationService,
    required this.getCheckinStatusUseCase,
    required this.performCheckinUseCase,
    required this.isUserInQueueUseCase,
    required this.authUseCase,
    required this.checkinRepository,
  }) : super(CheckinState(
    destination: CapitalEntity(cityName: '', coords: const LatLng(0,0), radius: 0),
    isLoading: true,
  ));

  Future<void> init() async {
    try {
      value = value.copyWith(isLoading: true);

      // 1. Busca o perfil para saber a baseCity
      final user = await authUseCase.getCurrentUser();
      if (user?.baseCity == null) throw Exception('Cidade base não cadastrada no perfil.');

      // 2. Busca dados geográficos no Supabase
      final destination = await checkinRepository.getDestinationByCityName(user!.baseCity!);
      
      // 3. Verifica se já está na fila
      bool inQueue = false;
      try {
        inQueue = await isUserInQueueUseCase();
      } catch (_) {}

      value = value.copyWith(
        destination: destination,
        isAlreadyInQueue: inQueue,
        isLoading: false,
      );

      startTracking();
    } catch (e) {
      value = value.copyWith(isLoading: false);
    }
  }

  void startTracking() async {
    final hasPermission = await locationService.checkPermission();
    if (!hasPermission) return;

    _positionStream = locationService.getPositionStream().listen(_updatePosition);
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
    if (destination.radius == 0) return;
    
    final distance = locationService.calculateDistance(
      position.latitude, position.longitude,
      destination.coords.latitude, destination.coords.longitude,
    );

    if (distance < 25000 && _cachedCity == null) {
      _cachedCity = await locationService.getCityFromCoordinates(
        position.latitude, position.longitude
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
    _positionStream?.cancel();
    super.dispose();
  }
}
