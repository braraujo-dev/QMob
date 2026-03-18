import 'package:alternative/features/home/domain/entities/driver_entity.dart';
import 'package:alternative/features/home/domain/repositories/driver_repository.dart';
import 'package:dartz/dartz.dart';

class GetDriversUseCase {
  final DriverRepository repository;
  GetDriversUseCase(this.repository);

  Future<Either<String, List<DriverEntity>>> call() async {
    return await repository.getDrivers();
  }
}
