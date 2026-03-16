import 'package:alternative/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:alternative/features/main/presentation/pages/main_page.dart';
import 'package:alternative/features/auth/presentation/pages/auth_page.dart';
import 'package:alternative/features/checkin/presentation/pages/checkin_page.dart';
import 'package:alternative/features/queue/presentation/pages/queue_page.dart';
import 'package:alternative/features/home/presentation/pages/admin_home_page.dart';
import 'package:alternative/features/home/presentation/pages/driver_register_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String auth = '/auth';
  static const String forgotPassword = '/forgotPassword';
  static const String main = '/main';
  static const String checkin = '/checkin';
  static const String queue = '/queue';
  static const String adminHome = '/adminHome';
  static const String driverRegister = '/driverRegister';

  static Map<String, WidgetBuilder> get routes => {
    auth: (context) => const AuthPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    main: (context) => const MainPage(),
    checkin: (context) => const CheckinPage(),
    queue: (context) => const QueuePage(),
    adminHome: (context) => const AdminHomePage(),
    driverRegister: (context) => const DriverRegisterPage(),
  };
}
