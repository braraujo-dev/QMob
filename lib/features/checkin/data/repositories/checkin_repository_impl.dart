import '../../domain/entities/capital_entity.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_remote_datasource.dart';

class CheckinRepositoryImpl implements CheckinRepository {
  final CheckinRemoteDataSource remoteDataSource;

  CheckinRepositoryImpl(this.remoteDataSource);

  @override
  Future<CapitalEntity> getDestinationByCityName(String cityName) async {
    return await remoteDataSource.getCapitalData(cityName);
  }
}
