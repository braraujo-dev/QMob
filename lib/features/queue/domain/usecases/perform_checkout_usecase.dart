import '../repositories/queue_repository.dart';

class PerformCheckoutUseCase {
  final QueueRepository repository;

  PerformCheckoutUseCase(this.repository);

  Future<void> call() async {
    await repository.performCheckout();
  }
}
