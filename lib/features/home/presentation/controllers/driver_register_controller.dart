import 'package:alternative/features/home/domain/usecases/get_capitals_usecase.dart';
import 'package:alternative/features/home/domain/usecases/get_driver_list_usecase.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/driver_entity.dart';
import '../../domain/usecases/register_driver_usecase.dart';
import 'driver_state.dart';

class DriverTegisterController extends ValueNotifier<DriverState> {
  final RegisterDriverUseCase registerDriverUseCase;
  final GetDriversUseCase getDriversUseCase;
  final GetCapitalsUseCase getCapitalsUseCase;
  
  List<DriverEntity> _allDrivers = [];
  List<DriverEntity> filteredDrivers = [];

  DriverTegisterController({
    required this.registerDriverUseCase,
    required this.getDriversUseCase,
    required this.getCapitalsUseCase,
  }) : super(DriverInitialState());

  List<String> capitals = [];

  Future<void> fetchCapitals() async {
    final result = await getCapitalsUseCase();
    result.fold((error) => value = DriverErrorState(error), (list) {
      capitals = list;
      notifyListeners();
    });
  }

  Future<void> fetchDrivers() async {
    value = DriverLoadingState();
    final result = await getDriversUseCase();

    result.fold(
      (error) => value = DriverErrorState(error),
      (list) {
        _allDrivers = list;
        filteredDrivers = list;
        value = DriverSuccessState();
      },
    );
  }

  void searchDrivers(String query) {
    if (query.isEmpty) {
      filteredDrivers = _allDrivers;
    } else {
      filteredDrivers = _allDrivers.where((driver) {
        final name = driver.name.toLowerCase();
        final plate = driver.vehiclePlate.toLowerCase();
        final search = query.toLowerCase();
        return name.contains(search) || plate.contains(search);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String vehicleModel,
    required String vehicleColor,
    required String baseCity,
    required String vehiclePlate,
    required String password,
  }) async {
    value = DriverLoadingState();

    final driver = DriverEntity(
      id: '',
      name: name,
      email: email,
      phone: phone,
      baseCity: baseCity,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      vehiclePlate: vehiclePlate,
    );

    final result = await registerDriverUseCase(driver, password);
    result.fold((error) => value = DriverErrorState(error), (_) => value = DriverSuccessState());
  }
}
