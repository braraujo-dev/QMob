import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/historic_model.dart';

abstract class HistoricRemoteDataSource {
  Future<List<HistoricModel>> getHistoric(String? userId);
  Stream<List<HistoricModel>> getHistoricStream(String? userId);
  Future<void> addHistoric(String userId, String origin, String destination, String status);
}

class HistoricRemoteDataSourceImpl implements HistoricRemoteDataSource {
  final SupabaseClient supabaseClient;
  HistoricRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<HistoricModel>> getHistoric(String? userId) async {
    try {
      var query = supabaseClient.from('historic').select();

      if (userId != null && userId.isNotEmpty) {
        query = query.eq('user_id', userId);
      }

      final response = await query.order('date', ascending: false);
      final list = response as List;
      return list.map((json) => HistoricModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar histórico: $e');
    }
  }

  @override
  Stream<List<HistoricModel>> getHistoricStream(String? userId) {
    return supabaseClient
        .from('historic')
        .stream(primaryKey: ['id'])
        .asyncMap((_) => getHistoric(userId));
  }

  @override
  Future<void> addHistoric(String userId, String origin, String destination, String status) async {
    await supabaseClient.from('historic').insert({
      'user_id': userId,
      'origin': origin,
      'destination': destination,
      'status': status,
      'date': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
