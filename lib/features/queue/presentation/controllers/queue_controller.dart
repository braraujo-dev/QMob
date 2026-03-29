import 'dart:async';
import 'package:flutter/material.dart';
import '../../../historic/domain/usecases/add_historic_usecase.dart';
import '../../domain/entities/driver_queue_entity.dart';
import '../../domain/usecases/get_queue_usecase.dart';
import '../../domain/usecases/perform_checkout_usecase.dart';
import '../../domain/repositories/queue_repository.dart';
import 'queue_state.dart';

class QueueController extends ValueNotifier<QueueState> {
  final GetQueueUseCase getQueueUseCase;
  final PerformCheckoutUseCase performCheckoutUseCase;
  final QueueRepository queueRepository;
  final AddHistoricUseCase addHistoricUseCase;
  
  StreamSubscription<List<DriverQueueEntity>>? _queueStreamSubscription;

  QueueController({
    required this.getQueueUseCase,
    required this.performCheckoutUseCase,
    required this.queueRepository,
    required this.addHistoricUseCase,
  }) : super(QueueInitialState());

  void startListening() {
    value = QueueLoadingState();
    
    _queueStreamSubscription?.cancel();
    _queueStreamSubscription = queueRepository.getQueueStream().listen(
      (queue) {
        if (queue.isEmpty) {
          value = QueueEmptyState();
        } else {
          final currentUser = queue.where((d) => d.isCurrentUser).firstOrNull;
          value = QueueLoadedState(queue: queue, currentUser: currentUser);
        }
      },
      onError: (e) {
        value = QueueErrorState(e.toString());
      },
    );
  }

  Future<void> fetchQueue() async {
    startListening();
  }

  Future<void> checkout() async {
    try {
      final currentState = value;
      if (currentState is QueueLoadedState && currentState.currentUser != null) {
        final String currentCapital = currentState.currentUser!.cityName;
        
        await performCheckoutUseCase();

        await addHistoricUseCase(
          origin: currentCapital.isNotEmpty ? currentCapital : 'Capital',
          destination: 'Base',
          status: 'Saída',
        );
      }
    } catch (e) {
      value = QueueErrorState(e.toString());
    }
  }

  @override
  void dispose() {
    _queueStreamSubscription?.cancel();
    super.dispose();
  }
}
