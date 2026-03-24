import 'package:alternative/features/home/domain/entities/profile_result.dart';
import 'package:alternative/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

import '../datasources/profile_remote_datasouurce.dart';

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

  // @override
  // Future<Either<String, void>> updateProfile(ProfileEntity profile, {File? imageFile}) async {
  //   try {
  //     // 1. Criamos um Map básico com o que é comum (ProfileModel)
  //     final model = ProfileModel(
  //       id: profile.id,
  //       email: profile.email,
  //       name: profile.name,
  //       phone: profile.phone,
  //     );

  //     // 2. Se for um Motorista, precisamos converter para DriverModel para incluir os veículos
  //     if (profile is DriverEntity) {
  //       final driverModel = DriverModel(
  //         id: profile.id,
  //         email: profile.email,
  //         name: profile.name,
  //         phone: profile.phone ?? '',
  //         photoUrl: profile.photoUrl,
  //         baseCity: profile.base,
  //         vehicleModel: profile.vehicleModel,
  //         vehicleColor: profile.vehicleColor,
  //         vehiclePlate: profile.vehiclePlate,
  //         assignedCapital: profile.assignedCapital,
  //       );
  //       await remoteDataSource.updateProfile(driverModel, imageFile: imageFile);
  //     } else {
  //       // 3. Se for Admin, enviamos o modelo base ou um AdminModel
  //       await remoteDataSource.updateProfile(model, imageFile: imageFile);
  //     }

  //     return const Right(null);
  //   } catch (e) {
  //     return Left(e.toString());
  //   }
  // }

  @override
  Future<void> signOut() async => await remoteDataSource.signOut();
}
