import 'package:alternative/features/profile/data/models/profile_model.dart';
import 'package:alternative/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<Either<String, ProfileModel>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}
