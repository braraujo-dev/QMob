import '../entities/driver_queue_entity.dart';

abstract class QueueRepository {
  Future<List<DriverQueueEntity>> getQueue();
  Stream<List<DriverQueueEntity>> getQueueStream();
  Future<void> performCheckin(String cityName);
  Future<void> performCheckout();
  Future<bool> isUserInQueue();
  Stream<bool> isUserInQueueStream();
}
