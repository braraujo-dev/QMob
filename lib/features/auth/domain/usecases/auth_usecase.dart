import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(email: email, password: password);
  }
}
