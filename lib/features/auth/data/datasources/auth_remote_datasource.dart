import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) throw Exception('Usuário não encontrado');

      final driverDoc = await supabaseClient
          .from('drivers')
          .select('base_city')
          .eq('id', response.user!.id)
          .maybeSingle();

      bool isAdmin = false;
      if (driverDoc == null) {
        final adminDoc = await supabaseClient
            .from('admins')
            .select('id')
            .eq('id', response.user!.id)
            .maybeSingle();
        isAdmin = adminDoc != null;
      }

      final String userRole = response.user!.appMetadata['role'] ?? (isAdmin ? 'admin' : 'driver');

      return UserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
        role: userRole,
        baseCity: driverDoc?['base_city'],
      );
    } catch (e) {
      throw Exception('Erro ao realizar login: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return null;

    final driverDoc = await supabaseClient
        .from('drivers')
        .select('base_city')
        .eq('id', user.id)
        .maybeSingle();

    final bool isAdmin = driverDoc == null;
    final String userRole = user.appMetadata['role'] ?? (isAdmin ? 'admin' : 'driver');

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      role: userRole,
      baseCity: driverDoc?['base_city'],
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await supabaseClient.auth.resetPasswordForEmail(email);
  }
}
