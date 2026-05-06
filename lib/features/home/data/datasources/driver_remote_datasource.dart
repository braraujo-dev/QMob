import 'package:alternative/core/config/env.dart';
import 'package:alternative/features/home/data/model/driver_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DriverRemoteDataSource {
  Future<void> registerDriver(DriverModel driver, String password);
  Future<List<DriverModel>> getAllDrivers();
  Future<void> deleteDriver(String driverId);
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

  @override
  Future<void> deleteDriver(String driverId) async {
    try {
      await supabase.from('queue').delete().eq('driver_id', driverId);
      await supabase.from('historic').delete().eq('user_id', driverId);
      
      final List<dynamic> result = await supabase
          .from('drivers')
          .delete()
          .eq('id', driverId)
          .select();
      
      if (result.isEmpty) {
        throw Exception("O banco de dados não permitiu a exclusão do registro. Verifique se as políticas de RLS (Políticas) no Supabase permitem que você delete motoristas.");
      }

    } on PostgrestException catch (e) {
      throw Exception("Erro no Banco (Supabase): ${e.message}");
    } catch (e) {
      rethrow;
    }
  }
}
