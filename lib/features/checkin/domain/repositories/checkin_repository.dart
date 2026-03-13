import '../entities/capital_entity.dart';

abstract class CheckinRepository {
  Future<List<CapitalEntity>> getCapitals();
  Future<CapitalEntity> getDestinationByCityName(String cityName);
}
