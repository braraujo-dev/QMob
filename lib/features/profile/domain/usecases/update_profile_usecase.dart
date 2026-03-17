import 'dart:io';
import 'package:dartz/dartz.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<String, void>> call(ProfileEntity profile, {File? imageFile}) async {
    return await repository.updateProfile(profile, imageFile: imageFile);
  }
}
