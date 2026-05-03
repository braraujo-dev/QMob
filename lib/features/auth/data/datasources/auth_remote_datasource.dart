import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
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

      // Verificação rigorosa: o usuário PRECISA existir em uma das tabelas de perfil
      final driverDoc = await supabaseClient
          .from('drivers')
          .select('id, base_city, must_change_password')
          .eq('id', response.user!.id)
          .maybeSingle();

      if (driverDoc != null) {
        return UserModel(
          id: response.user!.id,
          email: response.user!.email ?? '',
          role: 'driver',
          baseCity: driverDoc['base_city'],
          mustChangePassword: driverDoc['must_change_password'] ?? false,
        );
      }

      final adminDoc = await supabaseClient
          .from('admins')
          .select('id, must_change_password')
          .eq('id', response.user!.id)
          .maybeSingle();
      
      if (adminDoc != null) {
        return UserModel(
          id: response.user!.id,
          email: response.user!.email ?? '',
          role: 'admin',
          baseCity: null,
          mustChangePassword: adminDoc['must_change_password'] ?? false,
        );
      }

      // Se não encontrou em nenhum lugar, a conta foi deletada da tabela publica
      await supabaseClient.auth.signOut();
      throw Exception('Sua conta foi removida ou desativada pelo administrador.');

    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erro ao realizar login: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return null;

    final driverDoc = await supabaseClient
        .from('drivers')
        .select('id, base_city, must_change_password')
        .eq('id', user.id)
        .maybeSingle();

    if (driverDoc != null) {
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        role: user.appMetadata['role'] ?? 'driver',
        baseCity: driverDoc['base_city'],
        mustChangePassword: driverDoc['must_change_password'] ?? false,
      );
    }

    final adminDoc = await supabaseClient
        .from('admins')
        .select('id, must_change_password')
        .eq('id', user.id)
        .maybeSingle();
    
    if (adminDoc == null) {
      await supabaseClient.auth.signOut();
      return null;
    }
    
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      role: 'admin',
      baseCity: null,
      mustChangePassword: adminDoc['must_change_password'] ?? false,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await supabaseClient.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
