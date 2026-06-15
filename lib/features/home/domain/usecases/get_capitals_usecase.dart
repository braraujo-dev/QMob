import 'package:qmob/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:dartz/dartz.dart';

class GetCapitalsUseCase {
  final CheckinRepository repository;

  GetCapitalsUseCase(this.repository);

  Future<Either<String, List<String>>> call() async {
    return await repository.getCapitalsNames();
  }
}
