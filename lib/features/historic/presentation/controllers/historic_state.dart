import '../../domain/entities/historic_entity.dart';

abstract class HistoricState {}

class HistoricInitialState extends HistoricState {}

class HistoricLoadingState extends HistoricState {}

class HistoricSuccessState extends HistoricState {
  final List<HistoricEntity> historic;
  HistoricSuccessState(this.historic);
}

class HistoricErrorState extends HistoricState {
  final String message;
  HistoricErrorState(this.message);
}
