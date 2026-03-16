import 'package:alternative/features/profile/data/datasources/profile_remote_datasouurce.dart';
import 'package:alternative/features/profile/data/models/profile_model.dart';
import 'package:alternative/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, ProfileModel>> getProfile(String userId) async {
    try {
      final result = await remoteDataSource.getProfile(userId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> logout() async => await remoteDataSource.signOut();
}
