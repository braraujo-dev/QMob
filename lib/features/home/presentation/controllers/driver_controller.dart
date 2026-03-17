// lib/features/driver_register/presentation/controllers/driver_controller.dart
import 'package:flutter/material.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/usecases/register_driver_usecase.dart';
import 'driver_state.dart';

class DriverController extends ValueNotifier<DriverState> {
  final RegisterDriverUseCase registerDriverUseCase;

  DriverController({required this.registerDriverUseCase}) : super(DriverInitialState());

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
      name: name,
      email: email,
      phone: phone,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      vehiclePlate: vehiclePlate,
      assignedCapital: assignedCapital,
    );

    final result = await registerDriverUseCase(driver, password);
    result.fold((error) => value = DriverErrorState(error), (_) => value = DriverSuccessState());
  }
}
