import 'dart:io';
import 'package:alternative/features/home/domain/entities/profile_result.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<String, ProfileResult>> getProfile(String userId, String role);
  Future<Either<String, void>> updateProfile(Object profile, {File? imageFile});
  Future<void> signOut();
}
