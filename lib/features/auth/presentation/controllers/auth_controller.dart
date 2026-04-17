import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/usecases/auth_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import 'auth_state.dart';

class AuthController extends ValueNotifier<AuthState> {
  final AuthUseCase authUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _biometricKey = 'use_biometry';

  AuthController({required this.authUseCase, required this.sendPasswordResetEmailUseCase})
    : super(AuthInitialState());

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricKey) ?? false;
  }

  Future<void> updateBiometricSetting(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, enabled);
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();

      if (!canCheck || !isSupported) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Acesse o Q Mob com sua biometria',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      return false;
    }
  }

  Future<String> getInitialRoute() async {
    try {
      final user = await authUseCase.getCurrentUser();

      if (user == null) return AppRoutes.auth;

      final bool biometricActive = await isBiometricEnabled();
      if (biometricActive) {
        final bool success = await authenticateWithBiometrics();
        if (!success) return AppRoutes.auth;
      }

      if (user.mustChangePassword) return AppRoutes.changePassword;
      return user.role == 'admin' ? AppRoutes.adminHome : AppRoutes.driverHome;
    } catch (e) {
      return AppRoutes.auth;
    }
  }

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
    result.fold((error) => value = AuthErrorState(error), (_) => value = AuthInitialState());
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
Olá, gostaria de solicitar o cadastro no sistema Q Mob.

DADOS DO SINDICATO:
- Nome: $nome
- CNPJ: $cnpj
- Responsável: $responsavel
- Contato: $telefone

Aguardo o retorno para finalização do acesso!
''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'fmoreirasouza701@gmail.com',
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
