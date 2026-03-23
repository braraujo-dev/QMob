abstract class ProfileEntity {
  final String id;
  final String email;
  final String name;
  final String? phone;

  ProfileEntity({required this.id, required this.email, required this.name, this.phone});
}
