import 'package:dartz/dartz.dart';
import '../../domain/entities/capital_entity.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_remote_datasource.dart';

class CheckinRepositoryImpl implements CheckinRepository {
  final CheckinRemoteDataSource remoteDataSource;

  CheckinRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, CapitalEntity>> getDestinationByCityName(String cityName) async {
    try {
      final result = await remoteDataSource.getCapitalData(cityName);
      return Right(result); // Agora retorna Right(Entidade)
    } catch (e) {
      return Left("Erro ao buscar dados da capital: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, List<String>>> getCapitalsNames() async {
    try {
      final names = await remoteDataSource.getAllCapitalsNames();
      return Right(names);
    } catch (e) {
      return Left("Erro ao carregar lista de capitais: ${e.toString()}");
    }
  }
}
