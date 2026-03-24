import 'package:alternative/features/home/data/model/admin_model.dart';
import 'package:alternative/features/home/data/model/driver_model.dart';
import 'package:alternative/features/home/domain/entities/profile_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  // Retornamos dynamic ou uma Entity comum a ambos
  Future<ProfileResult> getProfile(String userId, String role);
  Future<void> signOut();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ProfileResult> getProfile(String userId, String role) async {
    if (role == 'admin') {
      final response = await supabaseClient.from('admins').select().eq('id', userId).single();
      // O AdminModel (Data) preenche a AdminEntity (Domain)
      return AdminProfile(AdminModel.fromMap(response));
    } else {
      final response = await supabaseClient.from('drivers').select().eq('id', userId).single();
      return DriverProfile(DriverModel.fromMap(response));
    }
  }

  // @override
  // Future<void> updateProfile(ProfileModel profile, {File? imageFile}) async {
  //   try {
  //     String? photoUrl = profile.photoUrl;

  //     // Se houver uma nova imagem, fazemos o upload para o Storage do Supabase
  //     if (imageFile != null) {
  //       final fileName = '${profile.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

  //       await supabaseClient.storage.from('avatars').upload(
  //         fileName,
  //         imageFile,
  //         fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
  //       );

  //       photoUrl = supabaseClient.storage.from('avatars').getPublicUrl(fileName);
  //     }

  //     final dataToUpdate = profile.toJson();
  //     if (photoUrl != null) {
  //       dataToUpdate['photo_url'] = photoUrl;
  //     }

  //     await supabaseClient
  //         .from('profiles')
  //         .update(dataToUpdate)
  //         .eq('id', profile.id);
  //   } catch (e) {
  //     throw ('Erro ao atualizar perfil: $e');
  //   }
  // }

  @override
  Future<void> signOut() async => await supabaseClient.auth.signOut();
}
