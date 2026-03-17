import 'dart:io';
import 'package:dartz/dartz.dart';
import '../datasources/profile_remote_datasouurce.dart';
import '../models/profile_model.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, ProfileEntity>> getProfile(String userId) async {
    try {
      final result = await remoteDataSource.getProfile(userId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateProfile(ProfileEntity profile, {File? imageFile}) async {
    try {
      final model = ProfileModel(
        id: profile.id,
        email: profile.email,
        name: profile.name,
        photoUrl: profile.photoUrl,
        phone: profile.phone,
        vehicleModel: profile.vehicleModel,
        vehiclePlate: profile.vehiclePlate,
        vehicleColor: profile.vehicleColor,
      );
      await remoteDataSource.updateProfile(model, imageFile: imageFile);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> signOut() async => await remoteDataSource.signOut();
}
