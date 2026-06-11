import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/driver_queue_entity.dart';
import '../../domain/repositories/queue_repository.dart';
import '../datasources/queue_remote_datasource.dart';

class QueueRepositoryImpl implements QueueRepository {
  final QueueRemoteDataSource remoteDataSource;
  final SupabaseClient supabaseClient;

  QueueRepositoryImpl(this.remoteDataSource, this.supabaseClient);

  @override
  Future<List<DriverQueueEntity>> getQueue() async {
    return await remoteDataSource.getQueue();
  }

  @override
  Stream<List<DriverQueueEntity>> getQueueStream() {
    return remoteDataSource.getQueueStream().map((models) => models.cast<DriverQueueEntity>());
  }

  @override
  Stream<bool> isUserInQueueStream() {
    final driverId = supabaseClient.auth.currentUser?.id;
    if (driverId == null) return Stream.value(false);
    return remoteDataSource.isUserInQueueStream(driverId);
  }

  @override
  Future<void> performCheckin(String cityName) async {
    final driverId = supabaseClient.auth.currentUser?.id;
    if (driverId == null) throw Exception('Usuário não autenticado');
    await remoteDataSource.performCheckin(driverId, cityName);
  }

  @override
  Future<void> performCheckout() async {
    final driverId = supabaseClient.auth.currentUser?.id;
    if (driverId == null) throw Exception('Usuário não autenticado');
    await remoteDataSource.performCheckout(driverId);
  }

  @override
  Future<bool> isUserInQueue() async {
    final driverId = supabaseClient.auth.currentUser?.id;
    if (driverId == null) return false;
    return await remoteDataSource.isUserInQueue(driverId);
  }
}
