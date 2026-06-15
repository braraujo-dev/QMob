import 'package:qmob/features/home/domain/entities/admin_entity.dart';
import 'package:qmob/features/home/domain/entities/driver_entity.dart';

sealed class ProfileResult {}

class AdminProfile extends ProfileResult {
  final AdminEntity admin;
  AdminProfile(this.admin);
}

class DriverProfile extends ProfileResult {
  final DriverEntity driver;
  DriverProfile(this.driver);
}

class ProfileNotFound extends ProfileResult {}
