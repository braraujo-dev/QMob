import 'package:dartz/dartz.dart';
import '../entities/driver_entity.dart';
import '../repositories/driver_repository.dart';

class RegisterDriverUseCase {
  final DriverRepository repository;
  RegisterDriverUseCase(this.repository);

  Future<Either<String, void>> call(DriverEntity driver, String password) async {
    return await repository.registerDriver(driver: driver, password: password);
  }
}
