import 'package:alternative/features/home/presentation/pages/admin_home_page.dart';
import 'package:alternative/features/home/presentation/pages/driver_register_page.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../features/checkin/presentation/pages/checkin_page.dart';

class AppRoutes {
  static const String initial = '/';
  static const String auth = '/auth';
  static const String adminHome = '/adminHome';
  static const String driverRegister = '/driverRegister';
  static const String checkin = '/checkin';

  static Map<String, WidgetBuilder> get routes => {
    auth: (context) => const AuthPage(),
    adminHome: (context) => const AdminHomePage(),
    driverRegister: (context) => const DriverRegisterPage(),
    checkin: (context) => const CheckinPage(),
  };
}
