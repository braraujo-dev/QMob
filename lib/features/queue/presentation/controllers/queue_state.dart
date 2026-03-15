import '../../domain/entities/driver_queue_entity.dart';

abstract class QueueState {}

class QueueInitialState extends QueueState {}

class QueueLoadingState extends QueueState {}

class QueueLoadedState extends QueueState {
  final List<DriverQueueEntity> queue;
  final DriverQueueEntity? currentUser;
  
  QueueLoadedState({required this.queue, this.currentUser});
}

class QueueEmptyState extends QueueState {}

class QueueErrorState extends QueueState {
  final String message;
  QueueErrorState(this.message);
}
