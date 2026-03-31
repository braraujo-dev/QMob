import 'package:alternative/core/config/env.dart';
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

      if (adminId == null) throw Exception("Sessão administrativa expirada.");

      final tempClient = SupabaseClient(
        Env.supabaseUrl,
        Env.supabaseAnonKey,
        authOptions: const AuthClientOptions(
          authFlowType: AuthFlowType.implicit,
          autoRefreshToken: false,
        ),
      );

      final AuthResponse res = await tempClient.auth.signUp(
        email: driver.email,
        password: password,
        data: {'role': 'driver'},
      );

      if (res.user != null) {
        final driverData = driver.toMap();
        driverData['id'] = res.user!.id;
        driverData['admin_id'] = adminId;

        await supabase.from('drivers').insert(driverData);

        await tempClient.auth.signOut();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DriverModel>> getAllDrivers() async {
    final adminId = supabase.auth.currentUser?.id;
    if (adminId == null) return [];

    final response = await supabase
        .from('drivers')
        .select()
        .eq('admin_id', adminId)
        .order('created_at', ascending: true);

    return (response as List).map((m) => DriverModel.fromMap(m)).toList();
  }
}
