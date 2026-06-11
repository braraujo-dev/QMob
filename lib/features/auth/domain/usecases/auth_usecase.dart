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

  Future<UserEntity?> getCurrentUser() async {
    return await repository.getCurrentUser();
  }

  Future<void> saveEmail(String email) async {
    await repository.saveRememberedEmail(email);
  }

  Future<String?> getSavedEmail() async {
    return await repository.getRememberedEmail();
  }

  Future<void> removeSavedEmail() async {
    await repository.removeRememberedEmail();
  }

  Future<void> signOut() async {
    await repository.signOut();
  }

  Future<Either<String, void>> sendUnionRequest({
    required String name,
    required String cnpj,
    required String responsible,
    required String phone,
  }) async {
    return await repository.saveUnionRequest(
      name: name,
      cnpj: cnpj,
      responsible: responsible,
      phone: phone,
    );
  }
}
