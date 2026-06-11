import 'package:dartz/dartz.dart';
import '../entities/historic_entity.dart';
import '../repositories/historic_repository.dart';

class GetHistoricUseCase {
  final HistoricRepository repository;

  GetHistoricUseCase(this.repository);

  Future<Either<String, List<HistoricEntity>>> call(String userId) async {
    return await repository.getHistoric(userId);
  }
}
