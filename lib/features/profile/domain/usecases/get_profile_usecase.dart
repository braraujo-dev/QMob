import 'package:alternative/features/home/domain/entities/profile_result.dart';
import 'package:dartz/dartz.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<String, ProfileResult>> call(String userId, String role) async {
    return await repository.getProfile(userId, role);
  }
}
