import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<String?> getBaseCity();
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

      final user = response.user;

      if (user == null) {
        throw Exception('Usuário não encontrado');
      }

      final String userRole = user.appMetadata['role'] ?? 'user';

      return UserModel(id: user.id, email: user.email ?? '', role: userRole);
    } catch (e) {
      throw Exception('Erro ao realizar login: ${e.toString()}');
    }
  }

  @override
  Future<String?> getBaseCity() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) return null;

      final response = await supabaseClient
          .from('drivers')
          .select('base_city')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null && response['base_city'] != null) {
        return response['base_city'] as String;
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao buscar cidade base: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Erro ao enviar email de recuperação: ${e.toString()}');
    }
  }
}
