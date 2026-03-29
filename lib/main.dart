import 'package:alternative/core/theme/app_theme.dart';
import 'package:alternative/features/auth/domain/usecases/auth_usecase.dart';
import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/config/env.dart';
import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);
  
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: Env.supabaseUrl, 
    anonKey: Env.supabaseAnonKey
  );

  await di.init();

  final authUseCase = sl<AuthUseCase>();
  final user = await authUseCase.getCurrentUser();
  final savedEmail = await authUseCase.getSavedEmail();

  String initialRoute = AppRoutes.auth;

  if (user != null && savedEmail != null) {
    if (user.mustChangePassword) {
      initialRoute = AppRoutes.changePassword;
    } else {
      initialRoute = user.isAdmin ? AppRoutes.adminHome : AppRoutes.driverHome;
    }
  } else {
    if (user != null && savedEmail == null) {
      await Supabase.instance.client.auth.signOut();
    }
    initialRoute = AppRoutes.auth;
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
    );
  }
}
