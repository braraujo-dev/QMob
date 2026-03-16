import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository repository;

  SendPasswordResetEmailUseCase(this.repository);

  Future<Either<String, void>> call(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      return const Left('Por favor, insira um e-mail válido.');
    }
    return await repository.sendPasswordResetEmail(email);
  }
}
