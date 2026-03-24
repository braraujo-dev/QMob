import 'dart:io';
import 'package:alternative/features/home/data/model/admin_model.dart';
import 'package:alternative/features/home/data/model/driver_model.dart';
import 'package:alternative/features/home/domain/entities/admin_entity.dart';
import 'package:alternative/features/home/domain/entities/driver_entity.dart';
import 'package:alternative/features/home/domain/entities/profile_result.dart';
import 'package:alternative/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, ProfileResult>> getProfile(String userId, String role) async {
    try {
      final result = await remoteDataSource.getProfile(userId, role);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateProfile(Object entity, {File? imageFile}) async {
    try {
      final Object modelToUpdate = switch (entity) {
        DriverModel m => m,
        AdminModel m => m,

        DriverEntity e => DriverModel(
          id: e.id,
          email: e.email,
          name: e.name,
          phone: e.phone,
          photoUrl: e.photoUrl,
          baseCity: e.baseCity,
          vehicleModel: e.vehicleModel,
          vehicleColor: e.vehicleColor,
          vehiclePlate: e.vehiclePlate,
          assignedCapital: e.assignedCapital,
        ),

        AdminEntity e => AdminModel(
          id: e.id,
          email: e.email,
          name: e.name,
          phone: e.phone,
          nomeSindicato: e.nomeSindicato,
          cnpj: e.cnpj,
          responsavel: e.responsavel,
          contato: e.contato,
        ),

        _ => throw Exception("Tipo de entidade não suportado"),
      };

      await remoteDataSource.updateProfile(modelToUpdate, imageFile: imageFile);

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> signOut() async => await remoteDataSource.signOut();
}
