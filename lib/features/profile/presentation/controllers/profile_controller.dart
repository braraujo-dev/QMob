import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileController extends ValueNotifier<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final SupabaseClient supabaseClient;

  ProfileController({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.supabaseClient,
  }) : super(ProfileInitialState());

  Future<void> fetchProfile() async {
    value = ProfileLoadingState();
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      value = ProfileErrorState('Usuário não autenticado');
      return;
    }
    final String userRole = user.appMetadata['role'] ?? "";
    final result = await getProfileUseCase(user.id, userRole);
    result.fold(
      (error) => value = ProfileErrorState(_mapErrorMessage(error)),
      (profile) => value = ProfileSuccessState(profile),
    );
  }

  Future<bool> changePassword(String newPassword) async {
    value = ProfileLoadingState();
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw Exception('Sessão expirada');

      final String role = user.appMetadata['role'] ?? 'driver';
      final table = role == 'admin' ? 'admins' : 'drivers';
      
      debugPrint('Tentando atualizar flag na tabela $table...');
      await supabaseClient
          .from(table)
          .update({'must_change_password': false})
          .eq('id', user.id);

      debugPrint('Tentando atualizar senha no Auth...');
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      debugPrint('Processo de troca de senha concluído com sucesso.');
      value = ProfileInitialState();
      return true;
    } on AuthException catch (e) {
      debugPrint('Erro Auth Supabase: ${e.message}');
      value = ProfileErrorState(_mapErrorMessage(e.message));
      return false;
    } catch (e) {
      debugPrint('Erro Genérico: $e');
      value = ProfileErrorState('Erro ao salvar nova senha. Tente novamente.');
      return false;
    }
  }

  Future<void> updateProfile(Object entity, {File? imageFile}) async {
    final currentState = value;
    value = ProfileLoadingState();
    final result = await updateProfileUseCase(entity, imageFile: imageFile);
    result.fold((error) {
      value = ProfileErrorState(_mapErrorMessage(error));
      if (currentState is ProfileSuccessState) value = currentState;
    }, (_) => fetchProfile());
  }

  String _mapErrorMessage(String error) {
    if (error.contains('different from the old password')) {
      return 'A nova senha deve ser diferente da senha atual.';
    }
    if (error.contains('at least 8 characters')) {
      return 'A senha deve ter no mínimo 8 caracteres.';
    }
    if (error.contains('Invalid login credentials')) {
      return 'E-mail ou senha incorretos.';
    }
    return 'Ops! Ocorreu um erro técnico. Verifique sua internet.';
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
