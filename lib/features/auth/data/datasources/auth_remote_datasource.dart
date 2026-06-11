import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<void> saveUnionRequest({
    required String name,
    required String cnpj,
    required String responsible,
    required String phone,
  });
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

  @override
  Future<void> saveUnionRequest({
    required String name,
    required String cnpj,
    required String responsible,
    required String phone,
  }) async {
    await supabaseClient.from('union_requests').insert({
      'union_name': name,
      'cnpj': cnpj,
      'responsible_name': responsible,
      'phone': phone,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
