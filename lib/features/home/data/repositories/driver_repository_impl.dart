import 'package:alternative/features/home/data/datasources/driver_remote_datasource.dart';
import 'package:alternative/features/home/data/model/driver_model.dart';
import 'package:alternative/features/home/domain/entities/driver_entity.dart';
import 'package:alternative/features/home/domain/repositories/driver_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        id: driver.id,
        name: driver.name,
        email: driver.email,
        phone: driver.phone,
        photoUrl: driver.photoUrl,
        baseCity: driver.baseCity,
        vehicleModel: driver.vehicleModel,
        vehicleColor: driver.vehicleColor,
        vehiclePlate: driver.vehiclePlate,
      );

      await remoteDataSource.registerDriver(model, password);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left("Erro ao salvar dados: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, List<DriverEntity>>> getDrivers() async {
    try {
      final list = await remoteDataSource.getAllDrivers();
      return Right(list);
    } catch (e) {
      return Left("Erro ao carregar motoristas: ${e.toString()}");
    }
  }
}
