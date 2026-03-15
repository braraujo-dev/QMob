import '../entities/driver_queue_entity.dart';

abstract class QueueRepository {
  Future<List<DriverQueueEntity>> getQueue();
  Future<void> performCheckin(String cityName);
  Future<void> performCheckout();
  Future<bool> isUserInQueue();
}
