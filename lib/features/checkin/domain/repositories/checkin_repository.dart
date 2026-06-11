import 'package:dartz/dartz.dart';

import '../entities/capital_entity.dart';

abstract class CheckinRepository {
  Future<Either<String, CapitalEntity>> getDestinationByCityName(String cityName);
  Future<Either<String, List<String>>> getCapitalsNames();
}
