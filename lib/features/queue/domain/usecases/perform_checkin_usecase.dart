import '../repositories/queue_repository.dart';

class PerformCheckinUseCase {
  final QueueRepository repository;

  PerformCheckinUseCase(this.repository);

  Future<void> call(String cityName) async {
    await repository.performCheckin(cityName);
  }
}
