import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/location_service.dart';
import '../../../auth/domain/usecases/auth_usecase.dart';
import '../../../queue/domain/repositories/queue_repository.dart';
import '../../../queue/domain/usecases/perform_checkin_usecase.dart';
import '../../../historic/domain/usecases/add_historic_usecase.dart';
import '../../domain/entities/capital_entity.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../../domain/usecases/get_checkin_status_usecase.dart';
import 'checkin_state.dart';

class CheckinController extends ValueNotifier<CheckinState> {
  final ILocationService locationService;
  final GetCheckinStatusUseCase getCheckinStatusUseCase;
  final PerformCheckinUseCase performCheckinUseCase;
  final AuthUseCase authUseCase;
  final CheckinRepository checkinRepository;
  final QueueRepository queueRepository;
  final AddHistoricUseCase addHistoricUseCase;

  StreamSubscription<Position>? _positionStream;
  StreamSubscription<bool>? _queueStream;
  String? _cachedCity;

  CheckinController({
    required this.locationService,
    required this.getCheckinStatusUseCase,
    required this.performCheckinUseCase,
    required this.authUseCase,
    required this.checkinRepository,
    required this.queueRepository,
    required this.addHistoricUseCase,
  }) : super(
         CheckinState(
           destination: CapitalEntity(cityName: '', coords: const LatLng(0, 0), radius: 0),
           isLoading: true,
         ),
       );

  Future<void> init() async {
    try {
      value = value.copyWith(isLoading: true);

      final inQueueInitially = await queueRepository.isUserInQueue();
      value = value.copyWith(isAlreadyInQueue: inQueueInitially);

      final user = await authUseCase.getCurrentUser();
      if (user?.baseCity == null) throw Exception('Cidade base não cadastrada no perfil.');

      final result = await checkinRepository.getDestinationByCityName(user!.baseCity!);

      result.fold(
        (error) {
          debugPrint('Erro ao buscar destino: $error');
          value = value.copyWith(isLoading: false);
        },
        (destination) {
          value = value.copyWith(destination: destination, isLoading: false);
          _setupQueueListener();
          startTracking();
        },
      );
    } catch (e) {
      debugPrint('Erro no init do Checkin: $e');
      value = value.copyWith(isLoading: false);
    }
  }

  void _setupQueueListener() {
    _queueStream?.cancel();
    _queueStream = queueRepository.isUserInQueueStream().listen(
      (inQueue) {
        if (value.isAlreadyInQueue != inQueue) {
          debugPrint('CheckinController: Status da fila alterado via Realtime -> $inQueue');
          value = value.copyWith(isAlreadyInQueue: inQueue);
        }
      },
      onError: (e) {
        debugPrint('Erro no Stream de Realtime: $e');
        Future.delayed(const Duration(seconds: 5), () => _setupQueueListener());
      },
    );
  }

  void startTracking() async {
    final hasPermission = await locationService.checkPermission();
    if (!hasPermission) return;

    _positionStream?.cancel();
    _positionStream = locationService.getPositionStream().listen(_updatePosition);
  }

  void stopTracking() {
    _positionStream?.cancel();
    _queueStream?.cancel();
  }

  Future<void> performCheckin() async {
    if (value.isAlreadyInQueue || value.isLoading || !value.isInsideGeofence) return;

    value = value.copyWith(isLoading: true);

    try {
      await performCheckinUseCase(value.destination.cityName);

      final user = await authUseCase.getCurrentUser();
      await addHistoricUseCase(
        origin: 'Base',
        destination: user?.baseCity ?? value.destination.cityName,
        status: 'Chegada',
      );

      value = value.copyWith(isLoading: false);
    } catch (e) {
      value = value.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> _updatePosition(Position position) async {
    final destination = value.destination;
    if (destination.radius == 0) return;

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
