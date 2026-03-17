import 'package:dartz/dartz.dart';
import '../entities/driver_entity.dart';

abstract class DriverRepository {
  Future<Either<String, void>> registerDriver({
    required DriverEntity driver,
    required String password,
  });
}
