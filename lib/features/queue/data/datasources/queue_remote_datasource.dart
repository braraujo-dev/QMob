import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/driver_queue_model.dart';

abstract class QueueRemoteDataSource {
  Future<List<DriverQueueModel>> getQueue();
  Future<void> performCheckin(String driverId, String cityName);
  Future<void> performCheckout(String driverId);
  Future<bool> isUserInQueue(String driverId);
}

class QueueRemoteDataSourceImpl implements QueueRemoteDataSource {
  final SupabaseClient supabaseClient;

  QueueRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<DriverQueueModel>> getQueue() async {
    try {
      final currentUserId = supabaseClient.auth.currentUser?.id ?? '';
      
      final response = await supabaseClient
          .from('queue')
          .select('*, profiles(full_name, vehicle_model, vehicle_color)')
          .order('checkin_time', ascending: true);

      return (response as List)
          .map((json) => DriverQueueModel.fromJson(json, currentUserId))
          .toList();
    } catch (e) {
      print('Erro ao buscar fila: $e');
      rethrow;
    }
  }

  @override
  Future<void> performCheckin(String driverId, String cityName) async {
    await supabaseClient.from('queue').insert({
      'driver_id': driverId,
      'city_name': cityName,
      'checkin_time': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> performCheckout(String driverId) async {
    await supabaseClient
        .from('queue')
        .delete()
        .eq('driver_id', driverId);
  }

  @override
  Future<bool> isUserInQueue(String driverId) async {
    final response = await supabaseClient
        .from('queue')
        .select('id')
        .eq('driver_id', driverId)
        .maybeSingle();
    
    return response != null;
  }
}
