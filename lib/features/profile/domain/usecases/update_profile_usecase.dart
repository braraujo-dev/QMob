import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  // O parâmetro 'profile' agora aceita DriverEntity ou AdminEntity
  // Future<Either<String, void>> call(Object profile, {File? imageFile}) async {
  //   return await repository.updateProfile(profile, imageFile: imageFile);
  // }
}
