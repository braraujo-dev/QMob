import '../entities/capital_entity.dart';

abstract class CheckinRepository {
  Future<CapitalEntity> getDestinationByCityName(String cityName);
}
