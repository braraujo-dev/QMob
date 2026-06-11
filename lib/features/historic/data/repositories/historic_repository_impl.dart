import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/historic_entity.dart';
import '../../domain/repositories/historic_repository.dart';
import '../datasources/historic_remote_datasource.dart';

class HistoricRepositoryImpl implements HistoricRepository {
  final HistoricRemoteDataSource remoteDataSource;
  final SupabaseClient supabaseClient;

  HistoricRepositoryImpl(this.remoteDataSource, this.supabaseClient);

  @override
  Future<Either<String, List<HistoricEntity>>> getHistoric(String userId) async {
    try {
      final result = await remoteDataSource.getHistoric(userId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<List<HistoricEntity>> getHistoricStream(String? userId) {
    return remoteDataSource
        .getHistoricStream(userId)
        .map((models) => models.cast<HistoricEntity>());
  }

  @override
  Future<Either<String, void>> addHistoric({
    required String origin,
    required String destination,
    required String status,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return const Left('Usuário não autenticado');
      await remoteDataSource.addHistoric(userId, origin, destination, status);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
