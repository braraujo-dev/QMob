import 'dart:io';

import 'package:alternative/features/home/data/model/admin_model.dart';
import 'package:alternative/features/home/data/model/driver_model.dart';
import 'package:alternative/features/home/domain/entities/profile_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResult> getProfile(String userId, String role);
  Future<void> updateProfile(Object model, {File? imageFile});
  Future<void> signOut();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ProfileResult> getProfile(String userId, String role) async {
    if (role == 'admin') {
      final response = await supabaseClient.from('admins').select().eq('id', userId).single();
      return AdminProfile(AdminModel.fromMap(response));
    } else {
      final response = await supabaseClient.from('drivers').select().eq('id', userId).single();
      return DriverProfile(DriverModel.fromMap(response));
    }
  }

  @override
  Future<void> updateProfile(Object model, {File? imageFile}) async {
    try {
      String table = '';
      String id = '';
      Map<String, dynamic> data = {};

      if (model is DriverModel) {
        table = 'drivers';
        id = model.id;
        data = model.toMap();
      } else if (model is AdminModel) {
        table = 'admins';
        id = model.id;
        data = model.toMap();
      }

      if (imageFile != null) {
        final fileName = '${id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await supabaseClient.storage
            .from('avatars')
            .upload(
              fileName,
              imageFile,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );

        final photoUrl = supabaseClient.storage.from('avatars').getPublicUrl(fileName);
        data['photo_url'] = photoUrl;
      }

      if (table.isEmpty) throw 'Tipo de perfil inválido para atualização';

      await supabaseClient.from(table).update(data).eq('id', id);
    } catch (e) {
      throw ('Erro ao atualizar perfil: $e');
    }
  }

  @override
  Future<void> signOut() async => await supabaseClient.auth.signOut();
}
