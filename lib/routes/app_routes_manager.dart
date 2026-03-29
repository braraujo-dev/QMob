import 'package:alternative/features/auth/presentation/pages/auth_page.dart';
import 'package:alternative/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:alternative/features/checkin/presentation/pages/checkin_page.dart';
import 'package:alternative/features/historic/presentation/pages/historic_page.dart';
import 'package:alternative/features/home/presentation/pages/admin_home_page.dart';
import 'package:alternative/features/home/presentation/pages/driver_register_page.dart';
import 'package:alternative/features/main/presentation/pages/driver_home_page.dart';
import 'package:alternative/features/profile/presentation/pages/profile_page.dart';
import 'package:alternative/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:alternative/features/profile/presentation/pages/change_password_page.dart';
import 'package:alternative/features/queue/presentation/pages/queue_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String auth = '/auth';
  static const String forgotPassword = '/forgot-password';
  static const String driverHome = '/driver-home';
  static const String checkin = '/checkin';
  static const String queue = '/queue';
  static const String adminHome = '/admin-home';
  static const String driverRegister = '/driver-register';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String historic = '/historic';
  static const String changePassword = '/change-password';

  static Map<String, WidgetBuilder> get routes => {
    auth: (context) => const AuthPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    driverHome: (context) => const DriverHomePage(),
    checkin: (context) => const CheckinPage(),
    queue: (context) => const QueuePage(),
    adminHome: (context) => const AdminHomePage(),
    driverRegister: (context) => const DriverRegisterPage(),
    profile: (context) => const ProfilePage(),
    editProfile: (context) => const EditProfilePage(),
    historic: (context) => const HistoricPage(),
    changePassword: (context) {
      final isFirstAccess = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
      return ChangePasswordPage(isFirstAccess: isFirstAccess);
    },
  };
}
