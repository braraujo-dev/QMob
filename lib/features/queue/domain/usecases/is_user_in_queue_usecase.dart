import '../repositories/queue_repository.dart';

class IsUserInQueueUseCase {
  final QueueRepository repository;

  IsUserInQueueUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isUserInQueue();
  }
}
