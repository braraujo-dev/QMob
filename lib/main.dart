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
  final user = authUseCase.getCurrentUser();
  final savedEmail = await authUseCase.getSavedEmail();

  final bool shouldGoToCheckin = user != null && savedEmail != null;

  runApp(MyApp(startInCheckin: shouldGoToCheckin));
}

class MyApp extends StatelessWidget {
  final bool startInCheckin;
  
  const MyApp({super.key, required this.startInCheckin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alternative App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: startInCheckin ? AppRoutes.checkin : AppRoutes.auth,
      routes: AppRoutes.routes,
    );
  }
}
