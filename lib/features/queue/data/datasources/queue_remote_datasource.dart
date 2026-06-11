import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/driver_queue_model.dart';

abstract class QueueRemoteDataSource {
  Future<List<DriverQueueModel>> getQueue();
  Stream<List<DriverQueueModel>> getQueueStream();
  Future<void> performCheckin(String driverId, String cityName);
  Future<void> performCheckout(String driverId);
  Future<bool> isUserInQueue(String driverId);
  Stream<bool> isUserInQueueStream(String driverId);
}

class QueueRemoteDataSourceImpl implements QueueRemoteDataSource {
  final SupabaseClient supabaseClient;
  String? _cachedAdminId;
  String? _cachedUserId;

  QueueRemoteDataSourceImpl(this.supabaseClient);

  Future<String?> _getAdminId() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      _cachedAdminId = null;
      _cachedUserId = null;
      return null;
    }

    if (_cachedUserId == user.id && _cachedAdminId != null) {
      return _cachedAdminId;
    }

    final role = user.appMetadata['role'];
    if (role == 'admin') {
      _cachedUserId = user.id;
      _cachedAdminId = user.id;
      return _cachedAdminId;
    }

    try {
      final driverData = await supabaseClient
          .from('drivers')
          .select('admin_id')
          .eq('id', user.id)
          .maybeSingle();
      
      _cachedUserId = user.id;
      _cachedAdminId = driverData?['admin_id'];
      return _cachedAdminId;
    } catch (e) {
      debugPrint('Erro ao buscar admin_id: $e');
      return null;
    }
  }

  @override
  Future<List<DriverQueueModel>> getQueue() async {
    try {
      final currentUserId = supabaseClient.auth.currentUser?.id ?? '';
      final adminId = await _getAdminId();

      if (adminId == null) return [];

      final response = await supabaseClient
          .from('queue')
          .select('*, drivers(full_name, vehicle_model, vehicle_color)')
          .eq('admin_id', adminId)
          .order('checkin_time', ascending: true);

      final list = response as List;
      return list.asMap().entries.map((entry) {
        return DriverQueueModel.fromJson(entry.value, currentUserId, entry.key);
      }).toList();
    } catch (e) {
      debugPrint('Erro em getQueue: $e');
      return [];
    }
  }

  @override
  Stream<List<DriverQueueModel>> getQueueStream() {
    return Stream.fromFuture(_getAdminId()).asyncExpand((adminId) {
      if (adminId == null) return Stream.value([]);
      
      return supabaseClient
          .from('queue')
          .stream(primaryKey: ['id'])
          .eq('admin_id', adminId)
          .order('checkin_time', ascending: true)
          .asyncMap((_) => getQueue());
    });
  }

  @override
  Stream<bool> isUserInQueueStream(String driverId) {
    return supabaseClient
        .from('queue')
        .stream(primaryKey: ['id'])
        .eq('driver_id', driverId)
        .map((event) => event.isNotEmpty);
  }

  @override
  Future<void> performCheckin(String driverId, String cityName) async {
    final adminId = await _getAdminId();
    if (adminId == null) throw Exception('Admin não encontrado para este motorista');

    await supabaseClient.from('queue').insert({
      'driver_id': driverId,
      'admin_id': adminId,
      'city_name': cityName,
      'checkin_time': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> performCheckout(String driverId) async {
    try {
      await supabaseClient
          .from('queue')
          .delete()
          .eq('driver_id', driverId)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Erro ao realizar checkout no Supabase: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isUserInQueue(String driverId) async {
    try {
      final response = await supabaseClient
          .from('queue')
          .select('id')
          .eq('driver_id', driverId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }
}
