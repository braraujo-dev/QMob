import 'package:dartz/dartz.dart';
import '../entities/historic_entity.dart';

abstract class HistoricRepository {
  Future<Either<String, List<HistoricEntity>>> getHistoric(String userId);
  Stream<List<HistoricEntity>> getHistoricStream(String userId); // Novo
  Future<Either<String, void>> addHistoric({
    required String origin,
    required String destination,
    required String status,
  });
}
