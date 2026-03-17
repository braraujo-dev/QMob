import 'package:alternative/features/home/data/model/driver_model.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/repositories/driver_repository.dart';
import '../datasources/driver_remote_datasource.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDataSource remoteDataSource;
  DriverRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, void>> registerDriver({
    required DriverEntity driver,
    required String password,
  }) async {
    try {
      final model = DriverModel(
        name: driver.name,
        email: driver.email,
        city: driver.city,
        cpf: driver.cpf,
      );
      await remoteDataSource.registerDriver(model, password);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
