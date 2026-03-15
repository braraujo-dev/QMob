import '../entities/driver_queue_entity.dart';
import '../repositories/queue_repository.dart';

class GetQueueUseCase {
  final QueueRepository repository;

  GetQueueUseCase(this.repository);

  Future<List<DriverQueueEntity>> call() async {
    return await repository.getQueue();
  }
}
