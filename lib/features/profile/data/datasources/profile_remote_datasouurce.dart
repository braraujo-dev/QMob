import 'package:alternative/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<void> signOut();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final user = supabaseClient.auth.currentUser;

      // 1. Busca os dados na tabela profiles
      final response = await supabaseClient.from('profiles').select().eq('id', userId).single();

      // 2. Verifica se é admin
      final bool isAdmin = response['is_admin'] ?? false;

      // 3. Retorna o Model (que é um subtipo de ProfileEntity)
      return ProfileModel.fromJson(response, user?.email ?? '', isAdmin);
    } catch (e) {
      throw ('Erro ao buscar perfil: $e');
    }
  }

  @override
  Future<void> signOut() async => await supabaseClient.auth.signOut();
}
