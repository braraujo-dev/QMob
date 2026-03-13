import 'package:flutter/material.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'auth_state.dart';

class AuthController extends ValueNotifier<AuthState> {
  final AuthUseCase authUseCase;

  AuthController(this.authUseCase) : super(AuthInitialState());

  bool isFormValid = false;
  bool rememberMe = false;
  
  String? emailError;
  String? passwordError;

  void validateForm(String email, String password) {
    if (email.isEmpty) {
      emailError = null;
    } else {
      final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
      emailError = emailValid ? null : 'E-mail inválido';
    }

    if (password.isEmpty) {
      passwordError = null;
    } else {
      passwordError = password.length >= 8 ? null : 'Mínimo 8 caracteres';
    }

    isFormValid = emailError == null && passwordError == null && email.isNotEmpty && password.isNotEmpty;
    notifyListeners();
  }

  void resetState() {
    value = AuthInitialState();
  }

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    value = AuthLoadingState();

    final result = await authUseCase.signIn(email: email, password: password);

    result.fold(
      (error) {
        String humanMessage = error;
        if (error.contains('Invalid login credentials')) {
          humanMessage = 'E-mail ou senha incorretos.';
        } else if (error.contains('network_error')) {
          humanMessage = 'Sem conexão com a internet.';
        }
        value = AuthErrorState(humanMessage);
      },
      (user) async {
        if (rememberMe) {
          await authUseCase.saveEmail(email);
        } else {
          await authUseCase.removeSavedEmail();
        }
        value = AuthSuccessState(user);
      },
    );
  }

  Future<String?> getSavedEmail() async {
    final email = await authUseCase.getSavedEmail();
    if (email != null) {
      rememberMe = true;
    }
    return email;
  }
}
