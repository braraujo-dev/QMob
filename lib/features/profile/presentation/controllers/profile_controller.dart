import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/profile_entity.dart';
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
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      value = ProfileErrorState('Usuário não autenticado');
      return;
    }

    final result = await getProfileUseCase(userId);
    result.fold(
      (error) => value = ProfileErrorState(error),
      (profile) => value = ProfileSuccessState(profile),
    );
  }

  Future<void> updateProfile(ProfileEntity profile, {File? imageFile}) async {
    final currentState = value;
    value = ProfileLoadingState();
    
    final result = await updateProfileUseCase(profile, imageFile: imageFile);
    
    result.fold(
      (error) {
        value = ProfileErrorState(error);
        if (currentState is ProfileSuccessState) {
          value = currentState;
        }
      },
      (_) => fetchProfile(),
    );
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
