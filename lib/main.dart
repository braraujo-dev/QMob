import 'package:alternative/core/theme/app_theme.dart';
import 'package:alternative/features/auth/domain/usecases/auth_usecase.dart';
import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/env.dart';
import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  await di.init();

  final authUseCase = sl<AuthUseCase>();
  final user = await authUseCase.getCurrentUser();
  final savedEmail = await authUseCase.getSavedEmail();

  String initialRoute = AppRoutes.auth;

  if (user != null && savedEmail != null) {
    initialRoute = user.isAdmin ? AppRoutes.adminHome : AppRoutes.main;
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alternative App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
