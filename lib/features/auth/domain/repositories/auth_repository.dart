import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signIn({required String email, required String password});
  Future<UserEntity?> getCurrentUser();
  Future<void> saveRememberedEmail(String email);
  Future<String?> getRememberedEmail();
  Future<void> removeRememberedEmail();
  Future<Either<String, void>> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<Either<String, void>> saveUnionRequest({
    required String name,
    required String cnpj,
    required String responsible,
    required String phone,
  });
}
