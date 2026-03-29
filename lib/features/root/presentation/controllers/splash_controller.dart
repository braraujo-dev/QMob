import 'package:alternative/features/auth/domain/usecases/auth_usecase.dart';
import 'package:alternative/features/profile/presentation/controllers/profile_controller.dart';
import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';

import 'splash_state.dart';

class SplashController extends ValueNotifier<SplashState> {
  final AuthUseCase authUseCase;
  final ProfileController profileController;

  SplashController({required this.authUseCase, required this.profileController})
    : super(SplashInitialState());

  Future<void> decideInitialRoute() async {
    value = SplashLoadingState();

    try {
      final user = await authUseCase.getCurrentUser();

      if (user == null) {
        value = SplashSuccessState(AppRoutes.auth);
        return;
      }

      final bool isBiometricActive = await profileController.getBiometricSetting();

      if (isBiometricActive) {
        final bool authenticated = await profileController.authenticateUser();

        if (!authenticated) {
          value = SplashSuccessState(AppRoutes.auth);
          return;
        }
      }

      String finalRoute;
      if (user.mustChangePassword) {
        finalRoute = AppRoutes.changePassword;
      } else {
        finalRoute = user.role == 'admin' ? AppRoutes.adminHome : AppRoutes.driverHome;
      }

      value = SplashSuccessState(finalRoute);
    } catch (e) {
      value = SplashErrorState("Erro ao inicializar aplicativo");
    }
  }
}
