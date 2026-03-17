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
      // Converte a Entity para o Model com os NOVOS campos
      final model = DriverModel(
        name: driver.name,
        email: driver.email,
        phone: driver.phone,
        vehicleModel: driver.vehicleModel,
        vehicleColor: driver.vehicleColor,
        vehiclePlate: driver.vehiclePlate,
        assignedCapital: driver.assignedCapital,
      );

      await remoteDataSource.registerDriver(model, password);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(e.message); // Captura erro de rate limit ou email já existe
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
