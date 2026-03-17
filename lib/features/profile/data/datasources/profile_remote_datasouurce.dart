import 'dart:io';
import 'package:alternative/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<void> signOut();
  Future<void> updateProfile(ProfileModel profile, {File? imageFile});
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
      throw ('Erro ao buscar perfil: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile, {File? imageFile}) async {
    try {
      String? photoUrl = profile.photoUrl;

      // Se houver uma nova imagem, fazemos o upload para o Storage do Supabase
      if (imageFile != null) {
        final fileName = '${profile.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        
        await supabaseClient.storage.from('avatars').upload(
          fileName,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

        photoUrl = supabaseClient.storage.from('avatars').getPublicUrl(fileName);
      }

      final dataToUpdate = profile.toJson();
      if (photoUrl != null) {
        dataToUpdate['photo_url'] = photoUrl;
      }

      await supabaseClient
          .from('profiles')
          .update(dataToUpdate)
          .eq('id', profile.id);
    } catch (e) {
      throw ('Erro ao atualizar perfil: $e');
    }
  }

  @override
  Future<void> signOut() async => await supabaseClient.auth.signOut();
}
