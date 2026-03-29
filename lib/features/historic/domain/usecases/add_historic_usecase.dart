import 'package:dartz/dartz.dart';
import '../repositories/historic_repository.dart';

class AddHistoricUseCase {
  final HistoricRepository repository;

  AddHistoricUseCase(this.repository);

  Future<Either<String, void>> call({
    required String origin,
    required String destination,
    required String status,
  }) async {
    return await repository.addHistoric(
      origin: origin,
      destination: destination,
      status: status,
    );
  }
}
