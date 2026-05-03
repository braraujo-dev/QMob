import 'package:alternative/features/home/domain/usecases/delete_driver_usecase.dart';
import 'package:alternative/features/home/domain/usecases/get_capitals_usecase.dart';
import 'package:alternative/features/home/domain/usecases/get_driver_list_usecase.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/driver_entity.dart';
import '../../domain/usecases/register_driver_usecase.dart';
import 'driver_state.dart';

class DriverRegisterController extends ValueNotifier<DriverState> {
  final RegisterDriverUseCase registerDriverUseCase;
  final GetDriversUseCase getDriversUseCase;
  final GetCapitalsUseCase getCapitalsUseCase;
  final DeleteDriverUseCase deleteDriverUseCase;

  List<DriverEntity> _allDrivers = [];
  List<DriverEntity> filteredDrivers = [];

  DriverRegisterController({
    required this.registerDriverUseCase,
    required this.getDriversUseCase,
    required this.getCapitalsUseCase,
    required this.deleteDriverUseCase,
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

    result.fold((error) => value = DriverErrorState(error), (list) {
      _allDrivers = list;
      filteredDrivers = list;
      value = DriverSuccessState();
    });
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
      adminId: null,
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

  Future<void> deleteDriver(String driverId) async {
    value = DriverLoadingState();
    final result = await deleteDriverUseCase(driverId);
    
    result.fold(
      (error) => value = DriverErrorState(error),
      (_) {
        _allDrivers.removeWhere((d) => d.id == driverId);
        filteredDrivers.removeWhere((d) => d.id == driverId);
        value = DriverSuccessState();
        notifyListeners();
      },
    );
  }
}
