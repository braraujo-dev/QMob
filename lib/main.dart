import 'package:alternative/core/theme/app_theme.dart';
import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/env.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: Env.supabaseUrl, 
    anonKey: Env.supabaseAnonKey
  );

  await di.init();

  final supabase = Supabase.instance.client;
  final session = supabase.auth.currentSession;

  String initialRoute = AppRoutes.auth;

  if (session != null && !session.isExpired) {
    final user = session.user;

    final String userRole = user.appMetadata['role'] ?? 'driver';

    initialRoute = switch (userRole) {
      'admin' => AppRoutes.adminHome,
      'driver' => AppRoutes.driverHome,
      _ => AppRoutes.auth,
    };
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
