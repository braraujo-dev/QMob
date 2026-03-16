import 'package:alternative/features/profile/data/models/profile_model.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<String, ProfileModel>> getProfile(String userId);
  Future<void> logout();
}
