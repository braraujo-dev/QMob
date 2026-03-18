import 'package:dartz/dartz.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<Either<String, ProfileEntity>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}
