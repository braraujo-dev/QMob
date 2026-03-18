import '../../domain/entities/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileEntity profile;
  ProfileSuccessState(this.profile);
}

class ProfileErrorState extends ProfileState {
  final String message;
  ProfileErrorState(this.message);
}
