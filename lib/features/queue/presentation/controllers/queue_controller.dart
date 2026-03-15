import 'package:flutter/material.dart';
import '../../domain/usecases/get_queue_usecase.dart';
import '../../domain/usecases/perform_checkout_usecase.dart';
import 'queue_state.dart';

class QueueController extends ValueNotifier<QueueState> {
  final GetQueueUseCase getQueueUseCase;
  final PerformCheckoutUseCase performCheckoutUseCase;

  QueueController({
    required this.getQueueUseCase,
    required this.performCheckoutUseCase,
  }) : super(QueueInitialState());

  Future<void> fetchQueue() async {
    value = QueueLoadingState();
    
    try {
      final queue = await getQueueUseCase();
      if (queue.isEmpty) {
        value = QueueEmptyState();
      } else {
        final currentUser = queue.where((d) => d.isCurrentUser).firstOrNull;
        value = QueueLoadedState(queue: queue, currentUser: currentUser);
      }
    } catch (e) {
      value = QueueErrorState(e.toString());
    }
  }

  Future<void> checkout() async {
    try {
      await performCheckoutUseCase();
      await fetchQueue();
    } catch (e) {
      value = QueueErrorState(e.toString());
    }
  }
}
