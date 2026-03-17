import 'dart:io';
import 'package:dartz/dartz.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<String, ProfileEntity>> getProfile(String userId);
  Future<Either<String, void>> updateProfile(ProfileEntity profile, {File? imageFile});
  Future<void> signOut();
}
