import 'package:alternative/features/home/data/model/driver_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DriverRemoteDataSource {
  Future<void> registerDriver(DriverModel driver, String password);
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final SupabaseClient supabase;
  DriverRemoteDataSourceImpl(this.supabase);

  @override
  Future<void> registerDriver(DriverModel driver, String password) async {
    // 1. Cria o usuário no Auth
    final AuthResponse res = await supabase.auth.signUp(email: driver.email, password: password);

    if (res.user != null) {
      // 2. Insere na tabela CORRETA (drivers)
      // e garante que o ID seja o do Auth
      final driverData = driver.toJson();
      driverData['id'] = res.user!.id; // Sobrescreve/insere o ID do auth

      await supabase.from('drivers').insert(driverData);
    }
  }
}
