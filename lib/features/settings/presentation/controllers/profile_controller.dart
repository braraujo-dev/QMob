// features/profile/presentation/controllers/profile_controller.dart
import 'package:alternative/features/settings/domain/repositories/profile_repository.dart';
import 'package:alternative/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:alternative/features/settings/presentation/controllers/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends ValueNotifier<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final ProfileRepository repository; // Para o logout direto
  final SupabaseClient supabase;

  ProfileController({
    required this.getProfileUseCase,
    required this.repository,
    required this.supabase,
  }) : super(ProfileInitialState());

  Future<void> fetchProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    value = ProfileLoadingState();
    final result = await getProfileUseCase(user.id);

    result.fold(
      (error) => value = ProfileErrorState(error),
      (profile) => value = ProfileSuccessState(profile),
    );
  }

  Future<void> signOut() async => await repository.logout();
}
