import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<void> saveRememberedEmail(String email);
  Future<String?> getRememberedEmail();
  Future<void> removeRememberedEmail();
  
  Future<UserEntity?> getCurrentUser();

  Future<Either<String, void>> sendPasswordResetEmail(String email);
}
