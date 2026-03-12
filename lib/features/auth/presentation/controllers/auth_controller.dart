import 'package:flutter/material.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'auth_state.dart';

class AuthController extends ValueNotifier<AuthState> {
  final AuthUseCase authUseCase;

  AuthController(this.authUseCase) : super(AuthInitialState());

  Future<void> signIn(String email, String password) async {
    value = AuthLoadingState();

    final result = await authUseCase.signIn(email: email, password: password);

    result.fold(
      (error) => value = AuthErrorState(error),
      (user) => value = AuthSuccessState(user),
    );
  }
}
