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
    if (value is QueueInitialState || value is QueueErrorState) {
      value = QueueLoadingState();
    }
    
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
        debugPrint('Erro no Stream da Fila: $e');
        value = QueueErrorState('Conexão instável. Verifique sua internet.');
      },
    );
  }

  Future<void> fetchQueue() async {
    startListening();
  }

  Future<void> checkout() async {
    final currentState = value;
    if (currentState is! QueueLoadedState || currentState.currentUser == null) return;

    final String currentCity = currentState.currentUser!.cityName;
    final previousState = value;
    
    value = QueueLoadingState();

    try {
      debugPrint('Realizando checkout...');
      
      await performCheckoutUseCase().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('O servidor demorou muito para responder.'),
      );

      addHistoricUseCase(
        origin: currentCity.isNotEmpty ? currentCity : 'Capital',
        destination: 'Base',
        status: 'Saída',
      ).catchError((e) => debugPrint('Erro ao salvar histórico: $e'));

      await Future.delayed(const Duration(milliseconds: 800));
      fetchQueue();
      
    } catch (e) {
      debugPrint('Erro fatal no checkout: $e');
      value = QueueErrorState('Falha ao sair da fila: ${e.toString()}');
      
      Future.delayed(const Duration(seconds: 3), () {
        if (value is QueueErrorState) {
          fetchQueue();
        }
      });
    }
  }

  @override
  void dispose() {
    _queueStreamSubscription?.cancel();
    super.dispose();
  }
}
