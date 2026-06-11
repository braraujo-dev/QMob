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

  Future<String?> _getAdminId() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return null;

    final role = user.appMetadata['role'];
    if (role == 'admin') return user.id;

    final driverData = await supabaseClient
        .from('drivers')
        .select('admin_id')
        .eq('id', user.id)
        .maybeSingle();
    
    return driverData?['admin_id'];
  }

  @override
  Future<List<HistoricModel>> getHistoric(String? userId) async {
    try {
      final adminId = await _getAdminId();
      if (adminId == null) return [];

      var query = supabaseClient.from('historic').select().eq('admin_id', adminId);

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
    return Stream.fromFuture(_getAdminId()).asyncExpand((adminId) {
      if (adminId == null) return Stream.value([]);
      
      return supabaseClient
          .from('historic')
          .stream(primaryKey: ['id'])
          .asyncMap((_) => getHistoric(userId));
    });
  }

  @override
  Future<void> addHistoric(String userId, String origin, String destination, String status) async {
    final adminId = await _getAdminId();
    if (adminId == null) throw Exception('Admin não encontrado');

    await supabaseClient.from('historic').insert({
      'user_id': userId,
      'admin_id': adminId,
      'origin': origin,
      'destination': destination,
      'status': status,
      'date': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
