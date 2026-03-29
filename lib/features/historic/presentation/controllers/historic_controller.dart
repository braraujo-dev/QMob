import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/historic_entity.dart';
import '../../domain/repositories/historic_repository.dart';
import '../../domain/usecases/get_historic_usecase.dart';
import 'historic_state.dart';

enum HistoricFilter { month, week, custom }

class HistoricController extends ValueNotifier<HistoricState> {
  final GetHistoricUseCase getHistoricUseCase;
  final HistoricRepository historicRepository;
  final SupabaseClient supabaseClient;

  HistoricFilter selectedFilter = HistoricFilter.month;
  DateTime? selectedDate;

  StreamSubscription<List<HistoricEntity>>? _historicSubscription;

  HistoricController({
    required this.getHistoricUseCase,
    required this.historicRepository,
    required this.supabaseClient,
  }) : super(HistoricInitialState());

  void setFilter(HistoricFilter filter, {DateTime? date}) {
    selectedFilter = filter;
    selectedDate = date;
    startListening();
  }

  void startListening() {
    value = HistoricLoadingState();
    
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      value = HistoricErrorState('Usuário não autenticado');
      return;
    }

    _historicSubscription?.cancel();
    _historicSubscription = historicRepository.getHistoricStream(userId).listen(
      (historic) {
        final filteredList = _applyFilter(historic);
        value = HistoricSuccessState(filteredList);
      },
      onError: (error) {
        value = HistoricErrorState(error.toString());
      },
    );
  }

  List<HistoricEntity> _applyFilter(List<HistoricEntity> historic) {
    final now = DateTime.now();
    return historic.where((item) {
      if (selectedFilter == HistoricFilter.week) {
        return item.date.isAfter(now.subtract(const Duration(days: 7)));
      } 
      
      if (selectedFilter == HistoricFilter.month) {
        return item.date.month == now.month && item.date.year == now.year;
      }

      if (selectedFilter == HistoricFilter.custom && selectedDate != null) {
        return item.date.day == selectedDate!.day &&
               item.date.month == selectedDate!.month &&
               item.date.year == selectedDate!.year;
      }

      return true;
    }).toList();
  }

  Future<void> fetchHistoric() async {
    startListening();
  }

  @override
  void dispose() {
    _historicSubscription?.cancel();
    super.dispose();
  }
}
