import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });
  
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Usuário não encontrado');
      }

      final profileResponse = await supabaseClient
          .from('profiles')
          .select('is_admin')
          .eq('id', response.user!.id)
          .single();

      return UserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
        isAdmin: profileResponse['is_admin'] ?? false,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user != null) {
      try {
        final profileResponse = await supabaseClient
            .from('profiles')
            .select('is_admin')
            .eq('id', user.id)
            .single();

        return UserModel(
          id: user.id, 
          email: user.email ?? '',
          isAdmin: profileResponse['is_admin'] ?? false,
        );
      } catch (_) {
        return UserModel(id: user.id, email: user.email ?? '', isAdmin: false);
      }
    }
    return null;
  }
}
