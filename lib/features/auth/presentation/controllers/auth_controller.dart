import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import 'auth_state.dart';

class AuthController extends ValueNotifier<AuthState> {
  final AuthUseCase authUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;

  AuthController({
    required this.authUseCase,
    required this.sendPasswordResetEmailUseCase,
  }) : super(AuthInitialState());

  bool isFormValid = false;
  bool rememberMe = false;

  String? emailError;
  String? passwordError;

  void validateForm(String email, String password) {
    if (email.isEmpty) {
      emailError = null;
    } else {
      final emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(email);
      emailError = emailValid ? null : 'E-mail inválido';
    }

    if (password.isEmpty) {
      passwordError = null;
    } else {
      passwordError = password.length >= 8 ? null : 'Mínimo 8 caracteres';
    }

    isFormValid =
        emailError == null && passwordError == null && email.isNotEmpty && password.isNotEmpty;
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

  Future<void> sendPasswordResetEmail(String email) async {
    value = AuthLoadingState();
    final result = await sendPasswordResetEmailUseCase(email);
    result.fold(
      (error) => value = AuthErrorState(error),
      (_) => value = AuthInitialState(), // Or a Success state if you prefer
    );
  }

  Future<String?> getSavedEmail() async {
    final email = await authUseCase.getSavedEmail();
    if (email != null) {
      rememberMe = true;
    }
    return email;
  }

  Future<bool> sendSindicatoRequest({
    required String nome,
    required String cnpj,
    required String responsavel,
    required String telefone,
  }) async {
    final String body =
        '''
Olá, gostaria de solicitar o cadastro no sistema Alternative.

DADOS DO SINDICATO:
- Nome: $nome
- CNPJ: $cnpj
- Responsável: $responsavel
- Contato: $telefone

Aguardo o retorno para finalização do acesso!
''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'felipemoreira512@outlook.com',
      query: _encodeQueryParameters({
        'subject': 'Solicitação de Cadastro: Sindicato de Motoristas',
        'body': body,
      }),
    );

    try {
      return await launchUrl(emailUri, mode: LaunchMode.externalNonBrowserApplication);
    } catch (e) {
      return false;
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value).replaceAll('+', '%20')}',
        )
        .join('&');
  }
}
