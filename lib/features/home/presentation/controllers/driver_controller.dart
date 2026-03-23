// lib/features/driver_register/presentation/controllers/driver_controller.dart
import 'package:alternative/core/utils/enum_class.dart';
import 'package:alternative/features/home/domain/usecases/get_driver_list_usecase.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/usecases/register_driver_usecase.dart';
import 'driver_state.dart';

class DriverController extends ValueNotifier<DriverState> {
  final RegisterDriverUseCase registerDriverUseCase;
  final GetDriversUseCase getDriversUseCase;

  List<DriverEntity> drivers = [];

  DriverController({required this.registerDriverUseCase, required this.getDriversUseCase})
    : super(DriverInitialState());

  Future<void> fetchDrivers() async {
    value = DriverLoadingState();
    final result = await getDriversUseCase();

    result.fold(
      (error) {
        return value = DriverErrorState(error);
      },
      (list) {
        drivers = list;
        value = DriverSuccessState(); // Ou crie um DriverLoadedState
      },
    );
  }

 // driver_controller.dart

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String vehicleModel,
    required String vehicleColor,
    required String vehiclePlate,
    required double assignedCapital,
    required String password,
  }) async {
    value = DriverLoadingState();

    final driver = DriverEntity(
      id: '', // Será gerado pelo banco
      name: name,
      email: email,
      phone: phone,
      userType: UserType.driver,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      vehiclePlate: vehiclePlate,
      assignedCapital: assignedCapital,
    );

    final result = await registerDriverUseCase(driver, password);
    result.fold(
      (error) => value = DriverErrorState(error), 
      (_) => value = DriverSuccessState(),
    );
  }
}
