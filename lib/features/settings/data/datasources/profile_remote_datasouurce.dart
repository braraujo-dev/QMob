import 'package:alternative/features/settings/data/models/profile_model.dart';
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
      final response = await supabaseClient.from('profiles').select().eq('id', userId).single();

      return ProfileModel.fromJson(response, user?.email ?? '');
    } catch (e) {
      throw Exception('Erro ao buscar perfil: $e');
    }
  }

  @override
  Future<void> signOut() async => await supabaseClient.auth.signOut();
}
