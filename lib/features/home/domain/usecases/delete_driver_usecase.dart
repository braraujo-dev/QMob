import 'package:dartz/dartz.dart';
import '../repositories/driver_repository.dart';

class DeleteDriverUseCase {
  final DriverRepository repository;

  DeleteDriverUseCase(this.repository);

  Future<Either<String, void>> call(String driverId) async {
    return await repository.deleteDriver(driverId);
  }
}
