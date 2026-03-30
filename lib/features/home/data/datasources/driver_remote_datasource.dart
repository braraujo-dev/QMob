import 'package:alternative/features/home/data/model/driver_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DriverRemoteDataSource {
  Future<void> registerDriver(DriverModel driver, String password);
  Future<List<DriverModel>> getAllDrivers();
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final SupabaseClient supabase;
  DriverRemoteDataSourceImpl(this.supabase);

  @override
  Future<void> registerDriver(DriverModel driver, String password) async {
    try {
      final adminId = supabase.auth.currentUser?.id;

      final AuthResponse res = await supabase.auth.signUp(
        email: driver.email,
        password: password,
        data: {'role': 'driver'},
      );

      if (res.user != null) {
        final driverData = driver.toMap();
        driverData['id'] = res.user!.id;
        driverData['admin_id'] = adminId;

        await supabase.from('drivers').insert(driverData);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DriverModel>> getAllDrivers() async {
    final response = await supabase.from('drivers').select().order('full_name');
    return (response as List).map((m) => DriverModel.fromMap(m)).toList();
  }
}
